// gen_docs_extract.dart — 全量 API 文档生成 + 单轨一致性校验工具（P14 / gen-docs 命令核心）
//
// 用法（由 scripts/gen_docs.{sh,ps1} 调用，也可手动执行）：
//   dart run scripts/gen_docs_extract.dart --root <workspaceRoot> \
//     [--pkg <name>] [--check-only] [--report]
//
// 功能（R20 文档单轨化：/// 注释是文档唯一来源）：
//   1. 遍历 packages/* 各包 barrel（lib/<pkg>.dart）的传递 export，
//      用 package:analyzer 解析提取全部公开 API，为每个 API 生成
//      独立文档页 docs/api/<name>.md：完整 /// 正文（[param] 链接转纯文本、
//      ```dart 示例原样保留）、参数表（名/类型/默认值/说明）、返回值、
//      类成员表（字段/方法 + 摘要）。
//   2. docs/api-index.md 生成导航总览页（按分类分组，链接 api/<name>.md）。
//   3. 一致性校验：docs/api/ 目录与导出 API 一一对应——多余文件（API 已删
//      但文档残留）报警；docs/ 下残留人工 md（非机械产物）报警。
//   4. --check-only 只做校验不生成文件；校验不通过退出码 1。
//
// 边界约定：
//   - 图标常量类等大成员数类不拆页：类级一页 + 完整成员表。
//   - 文档注释中的 @docImport 指令行不输出到 md。

import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:path/path.dart' as p;

class ParamInfo {
  final String name;
  final String type;
  final String defaultText; // 必填 / 可选 / `= expr`
  final String doc; // 从 /// 中 [name] 段提取
  ParamInfo(this.name, this.type, this.defaultText, this.doc);
}

class MemberInfo {
  final String name;
  final String kind; // 字段/静态属性/方法/静态方法/属性/构造/枚举值
  final String type; // 字段类型或方法返回类型
  final String summary; /// 首句摘要
  final List<ParamInfo> params;
  final String fullDoc; // 完整 /// 正文（markdown），可为空
  final String signature;
  MemberInfo(this.name, this.kind, this.type, this.summary, this.params,
      this.fullDoc, this.signature,);
}

class ApiDoc {
  final String name;
  final String kind; // 类/枚举/混入/扩展/函数/常量/变量/类型定义
  final String summary;
  final String fullDoc;
  final String signature;
  final String returnType;
  final List<ParamInfo> params;
  final List<MemberInfo> members;
  ApiDoc(this.name, this.kind, this.summary, this.fullDoc, this.signature,
      this.returnType, this.params, this.members,);
}

Future<void> main(List<String> args) async {
  String? root;
  final pkgs = <String>[];
  var checkOnly = false;
  var report = false;
  for (var i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--root':
        root = args[++i];
      case '--pkg':
        pkgs.add(args[++i]);
      case '--check-only':
        checkOnly = true;
      case '--report':
        report = true;
      default:
        stderr.writeln('[错误] 未知参数: ${args[i]}');
        exit(2);
    }
  }
  if (root == null || root.isEmpty) {
    stderr.writeln('[错误] 缺少 --root 参数');
    exit(2);
  }
  final rootDir = p.normalize(p.absolute(root));
  final packagesDir = p.join(rootDir, 'packages');
  final allPkgs = Directory(packagesDir)
      .listSync()
      .whereType<Directory>()
      .where((d) => File(p.join(d.path, 'pubspec.yaml')).existsSync())
      .map((d) => p.basename(d.path))
      .toList()
    ..sort();
  final targets = pkgs.isEmpty ? allPkgs : pkgs;
  for (final t in pkgs) {
    if (!allPkgs.contains(t)) {
      stderr.writeln('[错误] 未知包: $t（可选: ${allPkgs.join(", ")}）');
      exit(2);
    }
  }

  final collection = AnalysisContextCollection(
    includedPaths: [rootDir, ...targets.map((n) => p.join(packagesDir, n))],
  );

  final sessionCache = <String, AnalysisContext>{};
  AnalysisSession sessionFor(String path) {
    final key = p.dirname(p.dirname(path)); // 包根目录（lib 的上一级）
    final ctx = sessionCache[key] ??= () {
      for (final c in collection.contexts) {
        if (p.equals(c.contextRoot.root.path, path) ||
            p.isWithin(c.contextRoot.root.path, path)) {
          return c;
        }
      }
      return collection.contexts.first;
    }();
    return ctx.currentSession;
  }

  var failed = false;
  final jsonResults = <Map<String, dynamic>>[];
  for (final name in targets) {
    final pkgDir = p.join(packagesDir, name);
    final barrel = File(p.join(pkgDir, 'lib', '$name.dart'));
    if (!barrel.existsSync()) {
      stdout.writeln('[警告] $name: 未找到 barrel lib/$name.dart，跳过');
      continue;
    }
    try {
      final result =
          await _processPackage(sessionFor, pkgDir, name, checkOnly, report);
      jsonResults.add(result);
      if ((result['missing'] as List).isNotEmpty ||
          (result['extra'] as List).isNotEmpty ||
          (result['humanResidue'] as List).isNotEmpty) {
        failed = true;
      }
    } catch (e, st) {
      stdout.writeln('[失败] $name: $e');
      stderr.writeln(st.toString());
      failed = true;
    }
  }
  if (report) {
    stdout.writeln(const JsonEncoder.withIndent('  ').convert(jsonResults));
  }
  exit(failed ? 1 : 0);
}

Future<List<(String, Set<String>?, Set<String>?)>> _collectExportedFiles(
  AnalysisSession Function(String) sessionFor,
  String barrelPath,
) async {
  final result = <(String, Set<String>?, Set<String>?)>[];
  final visited = <String>{};
  Future<void> walk(String path, Set<String>? show, Set<String>? hide) async {
    if (!visited.add(path)) return;
    result.add((path, show, hide));
    final unit = await sessionFor(path).getResolvedUnit(path);
    if (unit is! ResolvedUnitResult) return;
    for (final d in unit.unit.directives.whereType<ExportDirective>()) {
      final exported = d.libraryExport?.exportedLibrary;
      final nextPath = exported?.firstFragment.source.fullName;
      if (nextPath == null || !File(nextPath).existsSync()) continue;
      Set<String>? show2;
      Set<String>? hide2;
      for (final c in d.libraryExport!.combinators) {
        if (c is ShowElementCombinator) {
          show2 ??= <String>{};
          show2.addAll(c.shownNames);
        } else if (c is HideElementCombinator) {
          hide2 ??= <String>{};
          hide2.addAll(c.hiddenNames);
        }
      }
      // 组合器叠加（父级 hide 与子级 show 交集语义近似：取子级优先）
      await walk(nextPath, show2 ?? show, hide2 ?? hide);
    }
  }

  await walk(barrelPath, null, null);
  return result;
}

Future<Map<String, dynamic>> _processPackage(
  AnalysisSession Function(String) sessionFor,
  String pkgDir,
  String name,
  bool checkOnly,
  bool report,
) async {
  final barrelPath = p.join(pkgDir, 'lib', '$name.dart');
  final files = await _collectExportedFiles(sessionFor, barrelPath);

  final exportedNames = <String>{};
  final pages = <ApiDoc>[];

  for (final (path, show, hide) in files) {
    final r = await sessionFor(path).getResolvedUnit(path);
    if (r is! ResolvedUnitResult) continue;
    for (final decl in r.unit.declarations) {
      final doc = _buildApiDoc(decl);
      if (doc == null) continue;
      if (doc.name.startsWith('_')) continue;
      if (show != null && !show.contains(doc.name)) continue;
      if (hide != null && hide.contains(doc.name)) continue;
      if (!exportedNames.add(doc.name)) continue;
      pages.add(doc);
    }
  }
  pages.sort((a, b) => a.name.compareTo(b.name));

  final docsDir = Directory(p.join(pkgDir, 'docs'));
  final apiDir = Directory(p.join(docsDir.path, 'api'));
  if (!checkOnly) {
    docsDir.createSync(recursive: true);
    apiDir.createSync(recursive: true);
    File(p.join(docsDir.path, 'api-index.md'))
        .writeAsStringSync(_renderIndex(name, pages));
    for (final doc in pages) {
      File(p.join(apiDir.path, '${doc.name}.md'))
          .writeAsStringSync(_renderPage(doc));
    }
  }

  // ---- 单轨一致性校验 ----
  final missing = <String>[]; // 期望页面存在但 api/ 缺失
  final extra = <String>[]; // api/ 有文件但 API 已不存在
  final humanResidue = <String>[]; // docs/ 下残留人工 md
  final expected = pages.map((d) => '${d.name}.md').toSet();
  if (apiDir.existsSync()) {
    for (final f in apiDir.listSync().whereType<File>()) {
      if (!f.path.endsWith('.md')) continue;
      final bn = p.basename(f.path);
      if (!expected.contains(bn)) extra.add(bn);
    }
    for (final e in expected) {
      if (!File(p.join(apiDir.path, e)).existsSync()) missing.add(e);
    }
  } else {
    missing.addAll(expected);
  }
  if (docsDir.existsSync()) {
    for (final node in docsDir.listSync()) {
      if (node is File && node.path.endsWith('.md')) {
        if (p.basename(node.path) != 'api-index.md') {
          humanResidue.add(p.basename(node.path));
        }
      }
    }
  }

  final problems =
      missing.isEmpty && extra.isEmpty && humanResidue.isEmpty;
  stdout.writeln(
      '${problems ? "[成功]" : "[警告]"} $name: 导出 ${pages.length} 项 | 页面缺失 ${missing.length} | 页面多余 ${extra.length} | 人工文档残留 ${humanResidue.length}',);
  if (missing.isNotEmpty) {
    stdout.writeln('  缺失页面（应生成而未生成）: ${missing.take(20).join(", ")}');
  }
  if (extra.isNotEmpty) {
    stdout.writeln(
        '  多余页面（API 已删但 docs/api/ 残留，请删除）: ${extra.take(20).join(", ")}',);
  }
  if (humanResidue.isNotEmpty) {
    stdout.writeln(
        '  人工文档残留（文档单轨化为机械生成，请删除）: ${humanResidue.join(", ")}',);
  }
  return {
    'package': name,
    'exported': pages.length,
    'missing': missing,
    'extra': extra,
    'humanResidue': humanResidue,
  };
}

// ---------------------------------------------------------------------------
// AST → ApiDoc
// ---------------------------------------------------------------------------

ApiDoc? _buildApiDoc(CompilationUnitMember decl) {
  switch (decl) {
    case final ClassDeclaration c:
      return ApiDoc(
        c.name.lexeme,
        '类',
        _firstSentence(_rawDoc(c.documentationComment)),
        _docToMarkdown(c.documentationComment),
        'class ${c.name.lexeme}',
        '',
        const [],
        _classMembers(c.members, c.name.lexeme),
      );
    case final EnumDeclaration e:
      return ApiDoc(
        e.name.lexeme,
        '枚举',
        _firstSentence(_rawDoc(e.documentationComment)),
        _docToMarkdown(e.documentationComment),
        'enum ${e.name.lexeme}',
        '',
        const [],
        [
          for (final c in e.constants)
            MemberInfo(
              c.name.lexeme,
              '枚举值',
              e.name.lexeme,
              _firstSentence(_rawDoc(c.documentationComment)),
              const [],
              _docToMarkdown(c.documentationComment),
              e.name.lexeme,
            ),
          ..._classMembers(e.members, e.name.lexeme),
        ],
      );
    case final MixinDeclaration m:
      return ApiDoc(
        m.name.lexeme,
        '混入',
        _firstSentence(_rawDoc(m.documentationComment)),
        _docToMarkdown(m.documentationComment),
        'mixin ${m.name.lexeme}',
        '',
        const [],
        _classMembers(m.members, m.name.lexeme),
      );
    case final ExtensionDeclaration x:
      final onType = x.declaredFragment?.element.extendedType
              .getDisplayString() ??
          '';
      final en = x.name?.lexeme ?? 'extension-on-$onType';
      return ApiDoc(
        en,
        '扩展',
        _firstSentence(_rawDoc(x.documentationComment)),
        _docToMarkdown(x.documentationComment),
        'extension ${x.name?.lexeme ?? ''} on $onType'.trim(),
        '',
        const [],
        _classMembers(x.members, en),
      );
    case final FunctionDeclaration f:
      final paramsNode = f.functionExpression.parameters;
      final isCallable = !f.isGetter &&
          !f.isSetter &&
          paramsNode != null;
      final ret = f.returnType?.toSource() ?? '';
      final sig = f.isGetter
          ? '$ret get ${f.name.lexeme}'
          : f.isSetter
              ? 'set ${f.name.lexeme}${paramsNode?.toSource() ?? ''}'
              : '$ret ${f.name.lexeme}${paramsNode?.toSource() ?? ''}';
      final raw = _rawDoc(f.documentationComment);
      final kind =
          isCallable ? '函数' : (f.isSetter ? '函数' : '常量');
      return ApiDoc(
        f.name.lexeme,
        kind,
        _firstSentence(raw),
        _docToMarkdown(f.documentationComment),
        sig,
        ret,
        isCallable ? _paramsOf(paramsNode, raw ?? '') : const [],
        const [],
      );
    case final TopLevelVariableDeclaration v:
      final first = v.variables.variables.first;
      final kw = v.variables.keyword?.lexeme ?? '';
      final type = v.variables.type?.toSource() ?? 'dynamic';
      return ApiDoc(
        first.name.lexeme,
        kw == 'const' ? '常量' : '变量',
        _firstSentence(_rawDoc(v.documentationComment)),
        _docToMarkdown(v.documentationComment),
        '$kw $type ${first.name.lexeme}'.trim(),
        type,
        const [],
        const [],
      );
    case final TypeAlias t:
      return ApiDoc(
        t.name.lexeme,
        '类型定义',
        _firstSentence(_rawDoc(t.documentationComment)),
        _docToMarkdown(t.documentationComment),
        'typedef ${t.name.lexeme}',
        '',
        const [],
        const [],
      );
    default:
      return null;
  }
}

List<MemberInfo> _classMembers(List<ClassMember> members, String owner) {
  final out = <MemberInfo>[];
  // 字段类型表：用于解析 `this.xxx` 形式构造参数的类型
  final fieldTypes = <String, String>{};
  for (final m in members) {
    if (m is FieldDeclaration) {
      final type = m.fields.type?.toSource() ?? 'dynamic';
      for (final v in m.fields.variables) {
        fieldTypes[v.name.lexeme] = type;
      }
    }
  }
  for (final m in members) {
    switch (m) {
      case final MethodDeclaration md:
        final raw = _rawDoc(md.documentationComment);
        final ret = md.returnType?.toSource() ?? '';
        final paramsNode = md.parameters;
        final sig = md.isGetter
            ? '$ret get ${md.name.lexeme}'
            : md.isSetter
                ? 'set ${md.name.lexeme}${paramsNode?.toSource() ?? ''}'
                : '$ret ${md.name.lexeme}${paramsNode?.toSource() ?? ''}';
        final isCallable = !md.isGetter && !md.isSetter && paramsNode != null;
        out.add(MemberInfo(
          md.name.lexeme,
          md.isStatic
              ? '静态方法'
              : (md.isGetter || md.isSetter ? '属性' : '方法'),
          ret.isEmpty ? 'void' : ret,
          _firstSentence(raw),
          isCallable ? _paramsOf(paramsNode, raw ?? '', fieldTypes: fieldTypes) : const [],
          _docToMarkdown(md.documentationComment),
          sig,
        ),);
      case final FieldDeclaration fd:
        final type = fd.fields.type?.toSource() ?? 'dynamic';
        for (final v in fd.fields.variables) {
          final raw = _rawDoc(fd.documentationComment);
          out.add(MemberInfo(
            v.name.lexeme,
            fd.isStatic ? '静态属性' : '字段',
            type,
            _firstSentence(raw),
            const [],
            _docToMarkdown(fd.documentationComment),
            '$type ${v.name.lexeme}',
          ),);
        }
      case final ConstructorDeclaration cd:
        final raw = _rawDoc(cd.documentationComment);
        final named = cd.name != null;
        final sig =
            '${cd.returnType.name}${named ? ".${cd.name!.lexeme}" : ""}'
            '${cd.parameters.toSource()}';
        out.add(MemberInfo(
          named ? '${cd.returnType.name}.${cd.name!.lexeme}' : cd.returnType.name,
          '构造',
          owner,
          _firstSentence(raw),
          _paramsOf(cd.parameters, raw ?? '', fieldTypes: fieldTypes),
          _docToMarkdown(cd.documentationComment),
          sig,
        ),);
    }
  }
  out.sort((a, b) {
    const order = {'构造': 0, '枚举值': 1, '字段': 2, '静态属性': 3, '属性': 4, '方法': 5, '静态方法': 6};
    final ka = order[a.kind] ?? 9, kb = order[b.kind] ?? 9;
    if (ka != kb) return ka.compareTo(kb);
    return a.name.compareTo(b.name);
  });
  return out;
}

List<ParamInfo> _paramsOf(
  FormalParameterList? list,
  String rawDoc, {
  Map<String, String> fieldTypes = const {},
}) {
  if (list == null) return const [];
  final out = <ParamInfo>[];
  for (final param in list.parameters) {
    final inner =
        param is DefaultFormalParameter ? param.parameter : param;
    final name = inner.name?.lexeme ?? '';
    if (name.isEmpty || name.startsWith('_')) continue;
    if (inner is SuperFormalParameter) continue; // super 参数见父类文档
    final String type;
    if (inner is FieldFormalParameter) {
      type = inner.type?.toSource() ?? fieldTypes[name] ?? 'dynamic';
    } else if (inner is SimpleFormalParameter) {
      type = inner.type?.toSource() ?? 'dynamic';
    } else {
      type = inner.toSource();
    }
    String defaultText;
    if (param.requiredKeyword != null) {
      defaultText = '必填';
    } else if (param is DefaultFormalParameter && param.defaultValue != null) {
      defaultText = '= ${param.defaultValue!.toSource()}';
    } else {
      defaultText = '可选';
    }
    out.add(ParamInfo(name, type, defaultText, _paramDoc(rawDoc, name)));
  }
  return out;
}

/// 从 /// 正文中提取 `[paramName]` 段的说明（直到空行 / 下一个 [xxx] 段 / 代码块）。
String _paramDoc(String rawDoc, String name) {
  final lines = rawDoc
      .split('\n')
      .map((l) => l.replaceFirst(RegExp(r'^///\s?'), ''))
      .toList();
  final start = RegExp('^\\[$name\\]\\s*(.*)\$');
  final other = RegExp('^\\[[A-Za-z_][A-Za-z0-9_]*\\]');
  final buf = <String>[];
  var inFence = false;
  var collecting = false;
  for (final line in lines) {
    if (line.trim().startsWith('```')) inFence = !inFence;
    if (inFence) {
      if (collecting) buf.add(line.trim());
      continue;
    }
    final m = start.firstMatch(line);
    if (m != null) {
      collecting = true;
      final rest = m.group(1)?.trim() ?? '';
      if (rest.isNotEmpty) buf.add(rest);
      continue;
    }
    if (collecting) {
      final t = line.trim();
      if (t.isEmpty || other.hasMatch(t) || t.startsWith('```')) break;
      buf.add(t);
    }
  }
  return buf.join(' ').replaceAllMapped(
        RegExp(r'\[([A-Za-z_][A-Za-z0-9_.]*)\](?!\()'),
        (m) => '`${m.group(1)}`',
      );
}

// ---------------------------------------------------------------------------
// 文档文本处理
// ---------------------------------------------------------------------------

String? _rawDoc(Comment? comment) =>
    comment?.tokens.map((t) => t.lexeme).join('\n');

/// /// 注释 → markdown：去 `///` 前缀、去 @docImport 行、代码块外 [Foo] 链接转纯文本。
String _docToMarkdown(Comment? comment) {
  if (comment == null) return '';
  final lines = <String>[];
  var inFence = false;
  for (final t in comment.tokens) {
    var line = t.lexeme.replaceFirst(RegExp(r'^///\s?'), '');
    if (line.trimLeft().startsWith('```')) inFence = !inFence;
    if (!inFence && line.trim().startsWith('@docImport')) continue;
    if (!inFence) {
      // [Foo] → `Foo`（代码块内不转换；排除 [text](url) 形式）
      line = line.replaceAllMapped(
        RegExp(r'\[([A-Za-z_][A-Za-z0-9_.]*)\](?!\()'),
        (m) => '`${m.group(1)}`',
      );
    }
    lines.add(line);
  }
  var text = lines.join('\n').trim();
  if (text.isEmpty) return '';
  return '$text\n';
}

/// 提取 /// 文档注释首句（去除 markdown 标记，限 60 字）
String _firstSentence(String? rawDoc) {
  if (rawDoc == null || rawDoc.trim().isEmpty) return '—';
  final text = rawDoc
      .split('\n')
      .map((l) => l.replaceFirst(RegExp(r'^///\s?'), '').trim())
      .where(
        (l) => l.isNotEmpty &&
            !l.startsWith('```') &&
            !l.startsWith('@docImport'),
      )
      .join(' ')
      .trim();
  if (text.isEmpty) return '—';
  final m = RegExp(r'^(.*?)([。；;]|\s-\s|\. )').firstMatch(text);
  var s = m != null ? (m.group(1) ?? text) : text;
  s = s.replaceAll(RegExp(r'[*_`\[\]]'), '').trim();
  if (s.length > 60) s = '${s.substring(0, 57)}…';
  return s.isEmpty ? '—' : s;
}

String _escapeTable(String s) => s.replaceAll('|', '\\|').replaceAll('\n', ' ');

String _paramTable(List<ParamInfo> params) {
  if (params.isEmpty) return '';
  final buf = StringBuffer();
  buf.writeln('| 名称 | 类型 | 默认值 | 说明 |');
  buf.writeln('| --- | --- | --- | --- |');
  for (final pa in params) {
    buf.writeln(
        '| `${pa.name}` | `${_escapeTable(pa.type)}` | ${_escapeTable(pa.defaultText)} | ${_escapeTable(pa.doc.isEmpty ? '—' : pa.doc)} |',);
  }
  buf.writeln();
  return buf.toString();
}

String _renderPage(ApiDoc doc) {
  final buf = StringBuffer();
  buf.writeln(
      '<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->',);
  buf.writeln();
  buf.writeln('# ${doc.name}');
  buf.writeln();
  buf.writeln('> 种类：${doc.kind}');
  buf.writeln();
  buf.writeln('```dart');
  buf.writeln(doc.signature);
  buf.writeln('```');
  buf.writeln();
  if (doc.fullDoc.isNotEmpty) {
    buf.write(doc.fullDoc);
    buf.writeln();
  }
  // 函数/带参构造：参数表 + 返回值
  final hasParams = doc.params.isNotEmpty;
  if (hasParams) {
    buf.writeln('## 参数');
    buf.writeln();
    buf.write(_paramTable(doc.params));
  }
  if (doc.kind == '函数' && doc.returnType.isNotEmpty && doc.returnType != 'void') {
    if (!hasParams) {
      buf.writeln('## 返回值');
      buf.writeln();
    }
    buf.writeln('返回 `${doc.returnType}`。');
    buf.writeln();
  }
  // 类 / 枚举 / 混入 / 扩展：成员表
  if (doc.members.isNotEmpty) {
    final constructors =
        doc.members.where((m) => m.kind == '构造').toList();
    final constants =
        doc.members.where((m) => m.kind == '枚举值').toList();
    final fields = doc.members
        .where((m) => m.kind == '字段' || m.kind == '静态属性')
        .toList();
    final properties = doc.members.where((m) => m.kind == '属性').toList();
    final methods = doc.members
        .where((m) => m.kind == '方法' || m.kind == '静态方法')
        .toList();

    if (constructors.isNotEmpty) {
      buf.writeln('## 构造函数');
      buf.writeln();
      for (final c in constructors) {
        buf.writeln('### `${c.signature}`');
        buf.writeln();
        if (c.fullDoc.isNotEmpty) {
          buf.write(c.fullDoc);
          buf.writeln();
        }
        buf.write(_paramTable(c.params));
      }
    }
    if (constants.isNotEmpty) {
      buf.writeln('## 枚举值');
      buf.writeln();
      buf.writeln('| 名称 | 说明 |');
      buf.writeln('| --- | --- |');
      for (final m in constants) {
        buf.writeln('| `${m.name}` | ${_escapeTable(m.summary)} |');
      }
      buf.writeln();
    }
    for (final section in [('字段', fields), ('属性', properties), ('方法', methods)]) {
      if (section.$2.isEmpty) continue;
      buf.writeln('## ${section.$1}');
      buf.writeln();
      buf.writeln('| 名称 | 类型 | 说明 |');
      buf.writeln('| --- | --- | --- |');
      for (final m in section.$2) {
        buf.writeln(
            '| `${m.name}` | `${_escapeTable(m.type)}` | ${_escapeTable(m.summary)} |',);
      }
      buf.writeln();
    }
  }
  return buf.toString();
}

String _renderIndex(String name, List<ApiDoc> pages) {
  final buf = StringBuffer();
  buf.writeln(
      '<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；源码 /// 注释变更后重跑 gen-docs -->',);
  buf.writeln();
  buf.writeln('# $name API 文档总览');
  buf.writeln();
  buf.writeln(
      '> 自动生成时间：${DateTime.now().toIso8601String()}；共 ${pages.length} 个公开 API，详情见 `api/<名称>.md` 独立页面。',);
  buf.writeln();
  final groups = <String, List<ApiDoc>>{};
  for (final d in pages) {
    groups.putIfAbsent(d.kind, () => []).add(d);
  }
  const order = ['类', '枚举', '混入', '扩展', '函数', '常量', '变量', '类型定义'];
  final kinds = groups.keys.toList()
    ..sort((a, b) {
      final ia = order.indexOf(a), ib = order.indexOf(b);
      return (ia < 0 ? 99 : ia).compareTo(ib < 0 ? 99 : ib);
    });
  for (final k in kinds) {
    buf.writeln('## $k（${groups[k]!.length}）');
    buf.writeln();
    buf.writeln('| 名称 | 说明 |');
    buf.writeln('| --- | --- |');
    for (final d in groups[k]!) {
      buf.writeln(
          '| [`${d.name}`](api/${Uri.encodeComponent(d.name)}.md) | ${_escapeTable(d.summary)} |',);
    }
    buf.writeln();
  }
  return buf.toString();
}
