// gen_docs_extract.dart — API 索引提取与双轨一致性校验工具（P12 / gen-docs 命令核心）
//
// 用法（由 scripts/gen_docs.{sh,ps1} 调用，也可手动执行）：
//   dart run scripts/gen_docs_extract.dart --root <workspaceRoot> \
//     [--pkg <name>] [--check-only] [--report]
//
// 功能：
//   1. 遍历 packages/* 各包 barrel（lib/<pkg>.dart）的传递 export，
//      用 package:analyzer 解析提取公开 类/枚举/混入/扩展/函数/常量/类型定义
//      及 /// 文档注释首句，生成 <pkg>/docs/api-index.md（按分类分组表格）。
//   2. 扫描 <pkg>/docs/*.md（不含 api-index.md）中出现的 API 名，
//      与实际导出比对，输出缺失（新 API 未写文档）/ 多余（文档提及但已不存在）清单。
//   3. --check-only 只做校验不生成文件；校验不通过退出码 1。
//
// 边界约定：
//   - 公开成员数 > 30 的类（如图标常量类）不逐项展开，输出汇总行。
//   - 一致性校验中"多余"仅统计反引号内 Ant*/ant* 前缀标识符，避免把 Flutter SDK 类型误报。
//   - 包无 docs/ 目录时不执行校验，输出 [跳过]。

import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:path/path.dart' as p;

const int kMaxMembersPerClass = 30;

class ApiEntry {
  final String name;
  final String kind; // 类/枚举/混入/扩展/函数/常量/类型定义
  final String summary;
  ApiEntry(this.name, this.kind, this.summary);
}

class ApiGroup {
  final String owner; // 类名 / 枚举名
  final List<ApiEntry> entries = [];
  ApiGroup(this.owner);
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
  AnalysisContext contextFor(String path) {
    for (final c in collection.contexts) {
      if (p.equals(c.contextRoot.root.path, path) ||
          p.isWithin(c.contextRoot.root.path, path)) {
        return c;
      }
    }
    return collection.contexts.first;
  }

  AnalysisSession sessionFor(String path) {
    final key = p.dirname(p.dirname(path)); // 包根目录（lib 的上一级）
    final ctx = sessionCache[key] ??= contextFor(path);
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
      final result = await _processPackage(
          sessionFor, pkgDir, name, checkOnly, report);
      jsonResults.add(result);
      if ((result['missing'] as List).isNotEmpty ||
          (result['extra'] as List).isNotEmpty) {
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

/// 传递 export 收集：返回 [(文件路径, show集合?, hide集合?)]（含 barrel 自身）
Future<List<(String, Set<String>?, Set<String>?)>> _collectExportedFiles(
  Future<ResolvedUnitResult?> Function(String) resolveUnit,
  String barrelPath,
) async {
  final result = <(String, Set<String>?, Set<String>?)>[];
  final visited = <String>{};
  Future<void> walk(String path, Set<String>? show, Set<String>? hide) async {
    if (!visited.add(path)) return;
    result.add((path, show, hide));
    final unit = await resolveUnit(path);
    if (unit == null) return;
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
  final files = await _collectExportedFiles((path) async {
    final r = await sessionFor(path).getResolvedUnit(path);
    return r is ResolvedUnitResult ? r : null;
  }, barrelPath);

  final exportedNames = <String>{};
  final topLevel = <ApiEntry>[];
  final memberGroups = <ApiGroup>[];

  String? libDoc;
  for (final (path, show, hide) in files) {
    final r = await sessionFor(path).getResolvedUnit(path);
    if (r is! ResolvedUnitResult) continue;
    final unit = r.unit;
    libDoc ??= _libraryDoc(unit);
    for (final decl in unit.declarations) {
      final (n, kind, doc, members) = _describeDeclaration(decl);
      if (n == null || n.startsWith('_')) continue;
      if (show != null && !show.contains(n)) continue;
      if (hide != null && hide.contains(n)) continue;
      if (!exportedNames.add(n)) continue;
      topLevel.add(ApiEntry(n, kind, _firstSentence(doc)));
      if (members != null && members.isNotEmpty) {
        final grp = ApiGroup(n);
        for (final (mn, mk, md) in members) {
          if (mn.startsWith('_')) continue;
          exportedNames.add(mn);
          grp.entries.add(ApiEntry(mn, mk, _firstSentence(md)));
        }
        grp.entries.sort((a, b) => a.name.compareTo(b.name));
        memberGroups.add(grp);
      }
    }
  }
  topLevel.sort((a, b) => a.name.compareTo(b.name));

  // 生成 api-index.md
  final docsDir = Directory(p.join(pkgDir, 'docs'));
  if (!checkOnly) {
    docsDir.createSync(recursive: true);
    final md = _renderIndex(name, libDoc, topLevel, memberGroups);
    File(p.join(docsDir.path, 'api-index.md')).writeAsStringSync(md);
  }

  // 一致性校验
  final missing = <String>[];
  final extra = <String>[];
  var hasHumanDocs = false;
  if (docsDir.existsSync()) {
    final buf = StringBuffer();
    for (final f in docsDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.md'))) {
      if (p.basename(f.path) == 'api-index.md') continue; // 机械产物不参与人工覆盖统计
      hasHumanDocs = true;
      buf.writeln(f.readAsStringSync());
    }
    final docsText = buf.toString();
    if (hasHumanDocs) {
      for (final e in topLevel) {
        if (!docsText.contains(e.name)) missing.add(e.name);
      }
      // 多余：反引号内 Ant 开头（PascalCase）标识符但不存在于导出（含类成员）。
      // 边界：仅检测 PascalCase 类名，避免把图标名（antCloud）/英文词（anthropic）/包名误报。
      final re = RegExp(r'`(Ant[A-Za-z0-9]+)`');
      final seen = <String>{};
      for (final m in re.allMatches(docsText)) {
        final n = m.group(1)!;
        if (!seen.add(n)) continue;
        if (!exportedNames.contains(n)) extra.add(n);
      }
    }
  }

  final status = !hasHumanDocs
      ? '[跳过]'
      : (missing.isEmpty && extra.isEmpty ? '[成功]' : '[警告]');
  final statLine = hasHumanDocs
      ? '导出 ${topLevel.length} 项 | 缺失 ${missing.length} | 多余 ${extra.length}'
      : '导出 ${topLevel.length} 项 | 无人工 docs/*.md，一致性校验跳过';
  stdout.writeln('$status $name: $statLine');
  if (missing.isNotEmpty) {
    stdout.writeln(
        '  缺失（新 API 未写入人工文档）: ${missing.take(20).join(", ")}${missing.length > 20 ? " …共${missing.length}项" : ""}');
  }
  if (extra.isNotEmpty) {
    stdout.writeln(
        '  多余（文档提及但已不存在）: ${extra.take(20).join(", ")}${extra.length > 20 ? " …共${extra.length}项" : ""}');
  }
  return {
    'package': name,
    'exported': topLevel.length,
    'missing': missing,
    'extra': extra,
  };
}

String? _libraryDoc(CompilationUnit unit) {
  final f = unit.directives.whereType<LibraryDirective>().firstOrNull;
  return f?.documentationComment?.tokens
      .map((t) => t.lexeme.replaceFirst(RegExp(r'^///\s?'), ''))
      .join('\n');
}

/// 描述顶层声明：返回 (名称, 分类, 文档注释, 类成员列表 或 null)
(String?, String, String?, List<(String, String, String?)>?) _describeDeclaration(
  CompilationUnitMember decl,
) {
  switch (decl) {
    case final ClassDeclaration c:
      return (
        c.name.lexeme,
        '类',
        c.documentationComment?.tokens.map((t) => t.lexeme).join('\n'),
        c.members
            .map(_describeClassMember)
            .whereType<(String, String, String?)>()
            .toList(),
      );
    case final EnumDeclaration e:
      return (
        e.name.lexeme,
        '枚举',
        e.documentationComment?.tokens.map((t) => t.lexeme).join('\n'),
        [
          // 枚举常量视为成员
          for (final c in e.constants)
            (
              c.name.lexeme,
              '枚举值',
              c.documentationComment?.tokens.map((t) => t.lexeme).join('\n'),
            ),
          ...e.members
              .map(_describeClassMember)
              .whereType<(String, String, String?)>(),
        ],
      );
    case final MixinDeclaration m:
      return (
        m.name.lexeme,
        '混入',
        m.documentationComment?.tokens.map((t) => t.lexeme).join('\n'),
        m.members
            .map(_describeClassMember)
            .whereType<(String, String, String?)>()
            .toList(),
      );
    case final ExtensionDeclaration x:
      return (
        x.name?.lexeme,
        '扩展',
        x.documentationComment?.tokens.map((t) => t.lexeme).join('\n'),
        x.members
            .map(_describeClassMember)
            .whereType<(String, String, String?)>()
            .toList(),
      );
    case final FunctionDeclaration f:
      final kind = (f.isGetter || f.isSetter || f.functionExpression.parameters == null)
          ? '常量'
          : '函数';
      return (
        f.name.lexeme,
        kind,
        f.documentationComment?.tokens.map((t) => t.lexeme).join('\n'),
        null,
      );
    case final TopLevelVariableDeclaration v:
      final kw = v.variables.keyword?.lexeme;
      final kind = kw == 'const' ? '常量' : '变量';
      return (
        v.variables.variables.first.name.lexeme,
        kind,
        v.documentationComment?.tokens.map((t) => t.lexeme).join('\n'),
        null,
      );
    case final TypeAlias t:
      return (
        t.name.lexeme,
        '类型定义',
        t.documentationComment?.tokens.map((t2) => t2.lexeme).join('\n'),
        null,
      );
    default:
      return (null, '其他', null, null);
  }
}

(String, String, String?)? _describeClassMember(ClassMember m) {
  switch (m) {
    case final MethodDeclaration md:
      return (
        md.name.lexeme,
        md.isStatic
            ? '静态方法'
            : (md.isGetter || md.isSetter ? '属性' : '方法'),
        md.documentationComment?.tokens.map((t) => t.lexeme).join('\n'),
      );
    case final FieldDeclaration fd:
      return (
        fd.fields.variables.first.name.lexeme,
        fd.isStatic ? '静态属性' : '字段',
        fd.documentationComment?.tokens.map((t) => t.lexeme).join('\n'),
      );
    case final ConstructorDeclaration cd:
      if (cd.name == null) return null;
      return (
        '${cd.returnType.name}${cd.factoryKeyword != null ? "" : "."}${cd.name!.lexeme}',
        '构造',
        cd.documentationComment?.tokens.map((t) => t.lexeme).join('\n'),
      );
    default:
      return null;
  }
}

/// 提取 /// 文档注释首句（按 。/；/换行截断，去除 markdown 标记，限 60 字）
String _firstSentence(String? doc) {
  if (doc == null || doc.trim().isEmpty) return '—';
  final text = doc
      .split('\n')
      .map((l) => l.replaceFirst(RegExp(r'^///\s?'), '').trim())
      .where((l) => l.isNotEmpty && !l.startsWith('```'))
      .join(' ')
      .trim();
  if (text.isEmpty) return '—';
  final m = RegExp(r'^(.*?)([。；;]|\s-\s|\. )').firstMatch(text);
  var s = m != null ? (m.group(1) ?? text) : text;
  s = s.replaceAll(RegExp(r'[*_`\[\]]'), '').trim();
  if (s.length > 60) s = '${s.substring(0, 57)}…';
  return s.isEmpty ? '—' : s;
}

String _renderIndex(
  String name,
  String? libDoc,
  List<ApiEntry> topLevel,
  List<ApiGroup> memberGroups,
) {
  final buf = StringBuffer();
  buf.writeln(
      '<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；源码 barrel 变更后重跑 gen-docs 命令 -->');
  buf.writeln();
  buf.writeln('# $name API 索引');
  buf.writeln();
  buf.writeln(
      '> 自动生成时间：${DateTime.now().toIso8601String()}；共 ${topLevel.length} 个顶层导出。');
  if (libDoc != null && libDoc.trim().isNotEmpty) {
    buf.writeln('>');
    for (final line in libDoc.trim().split('\n')) {
      buf.writeln('> $line');
    }
  }
  buf.writeln();

  final groups = <String, List<ApiEntry>>{};
  for (final e in topLevel) {
    groups.putIfAbsent(e.kind, () => []).add(e);
  }
  const order = ['类', '枚举', '混入', '扩展', '函数', '常量', '变量', '类型定义', '其他'];
  final kinds = groups.keys.toList()
    ..sort((a, b) {
      final ia = order.indexOf(a), ib = order.indexOf(b);
      return (ia < 0 ? 99 : ia).compareTo(ib < 0 ? 99 : ib);
    });

  buf.writeln('## 顶层导出');
  buf.writeln();
  for (final k in kinds) {
    buf.writeln('### $k（${groups[k]!.length}）');
    buf.writeln();
    buf.writeln('| 名称 | 类型 | 说明 |');
    buf.writeln('| --- | --- | --- |');
    for (final e in groups[k]!) {
      buf.writeln('| `${e.name}` | ${e.kind} | ${e.summary.replaceAll('|', '\\|')} |');
    }
    buf.writeln();
  }

  buf.writeln('## 类 / 枚举成员');
  buf.writeln();
  for (final g in memberGroups) {
    if (g.entries.isEmpty) continue;
    if (g.entries.length > kMaxMembersPerClass) {
      buf.writeln(
          '### `${g.owner}`（${g.entries.length} 个公开成员，超过 $kMaxMembersPerClass 不逐项展开，完整清单见包内 catalog 文档）');
      buf.writeln();
      continue;
    }
    buf.writeln('### `${g.owner}`');
    buf.writeln();
    buf.writeln('| 名称 | 类型 | 说明 |');
    buf.writeln('| --- | --- | --- |');
    for (final e in g.entries) {
      buf.writeln('| `${e.name}` | ${e.kind} | ${e.summary.replaceAll('|', '\\|')} |');
    }
    buf.writeln();
  }
  return buf.toString();
}
