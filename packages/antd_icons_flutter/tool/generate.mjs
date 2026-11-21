#!/usr/bin/env node
/**
 * generate.mjs — antd_icons_flutter 图标资源全量生成脚本
 *
 * 从 npm registry 远程下载最新 @ant-design/icons-svg 包，
 * 自动生成以下产物：
 *   1. fonts/AntIcons.ttf             — TTF 字体（outlined + filled）
 *   2. assets/twotone/*.svg           — TwoTone 双色图标 SVG 资产（颜色已规范化）
 *   3. lib/src/ant_icons.dart         — AntIcons 常量类（IconData，TTF 码点）
 *   4. lib/src/ant_icons_twotone.dart — AntIconsTwotone 常量类（SVG 资产路径）
 *
 * 用法（在任何电脑上）:
 *   cd tool && npm install && node generate.mjs
 *
 * 可选参数:
 *   --version <ver>   指定 @ant-design/icons-svg 版本（默认 latest）
 *   --clean           清理缓存后重新下载
 *   --registry <url>  指定 npm registry 地址
 */

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { execSync } from 'node:child_process';
import { Readable } from 'node:stream';
import SVGIcons2SVGFontStream from 'svgicons2svgfont';
import svg2ttf from 'svg2ttf';

// ── 路径配置（自动推导，不依赖工作目录） ──────────────────
const SCRIPT_DIR = path.dirname(fileURLToPath(import.meta.url));
const PKG_ROOT = path.resolve(SCRIPT_DIR, '..');
const CACHE_DIR = path.join(SCRIPT_DIR, '.cache');

const OUT_FONT = path.join(PKG_ROOT, 'fonts', 'AntIcons.ttf');
const OUT_TWOTONE_DIR = path.join(PKG_ROOT, 'assets', 'twotone');
const OUT_ANT_ICONS = path.join(PKG_ROOT, 'lib', 'src', 'ant_icons.dart');
const OUT_ANT_ICONS_TWOTONE = path.join(PKG_ROOT, 'lib', 'src', 'ant_icons_twotone.dart');

const NPM_REGISTRY = getArg('--registry') || 'https://registry.npmjs.org';
const PKG_NAME = '@ant-design/icons-svg';

const ANT_ICONS_CLASS_DOC = [
  "/// Ant Design 图标集（TTF 字体模式）。",
  "///",
  "/// 覆盖 Outlined（线框，447 个）与 Filled（实心，251 个）两种风格，共 698 个",
  "/// [IconData] 常量，源 [`@ant-design/icons-svg`](https://github.com/ant-design/ant-design-icons)。",
  "///",
  "/// ## 命名规则",
  "///",
  "/// 与 antd React 版对齐（camelCase + 风格后缀）：",
  "/// - `<CheckOutlined />` → [AntIcons.checkOutlined]",
  "/// - `<CheckCircleFilled />` → [AntIcons.checkCircleFilled]",
  "///",
  "/// 同名图标若两种风格均有，则后缀不同、基础名一致（如 `heartOutlined` / `heartFilled`）。",
  "///",
  "/// ## 字体资产加载",
  "///",
  "/// 全部 Outlined/Filled 图标打包在单一字体文件 `fonts/AntIcons.ttf` 中，",
  "/// 已在包内 `pubspec.yaml` 注册为字体族 `AntIcons`（`fontPackage: 'antd_icons_flutter'`）。",
  "/// 常量通过 `fontFamily` + PUA（私用区）码点引用字形，宿主应用引入本包后",
  "/// 无需任何额外配置，Flutter 引擎会在首次渲染时按需加载字体。",
  "///",
  "/// ## Tree-shaking 说明",
  "///",
  "/// 与 Material Icons 不同，**本字体不做按码点 tree-shaking**：字体文件整体",
  "/// 打入应用（约数百 KB 级）。若对包体积敏感，可考虑：",
  "/// - 仅使用 [AntIconsTwotone]（SVG 资产，按文件粒度打包）；",
  "/// - 自行使用 `flutter icon_font` 类工具裁剪字体。",
  "///",
  "/// 但无论使用其中多少个常量，字体均以整文件形式随应用发布，未引用的码点",
  "/// 不会额外占用运行时内存，仅占用安装包体积。",
  "///",
  "/// ## 用法",
  "///",
  "/// 直接用于 Flutter [Icon] 组件，或经由统一组件 [AntdIcon]：",
  "///",
  "/// ```dart",
  "/// Icon(AntIcons.checkOutlined)",
  "/// Icon(AntIcons.searchOutlined, size: 24, color: Colors.blue)",
  "/// AntdIcon(AntIcons.checkCircleFilled, size: 32, color: Colors.green)",
  "/// ```",
  "///",
  "/// 枚举辅助列表（用于图标选择器等场景）：",
  "///",
  "/// ```dart",
  "/// for (final (name, icon) in AntIcons.outlinedIcons) { /* ... */ }",
  "/// ```",
];

const TWOTONE_CLASS_DOC = [
  "/// Ant Design TwoTone 双色图标集（SVG 资产路径）。",
  "///",
  "/// 共 150 个双色图标，源 [`@ant-design/icons-svg`](https://github.com/ant-design/ant-design-icons)。",
  "///",
  "/// ## 命名规则",
  "///",
  "/// 与 antd React 版对齐（camelCase + `TwoTone` 后缀）：",
  "/// - `<CheckCircleTwoTone />` → [AntIconsTwotone.checkCircleTwoTone]",
  "///",
  "/// ## 渲染方式",
  "///",
  "/// 常量值为包内 SVG 资产路径（如 `assets/twotone/check-circle.svg`），",
  "/// 经由 [AntdIcon] 组件渲染（内部使用 `flutter_svg` + 运行时双色替换）：",
  "///",
  "/// ```dart",
  "/// AntdIcon(AntIconsTwotone.checkCircleTwoTone)",
  "/// AntdIcon(AntIconsTwotone.heartTwoTone,",
  "///     twoToneColor: Colors.red)",
  "/// ```",
  "///",
  "/// 也可不经过 [AntdIcon]，用 `flutter_svg` 的 `SvgPicture.asset` 直接加载",
  "/// （注意传入 `package: 'antd_icons_flutter'`）：",
  "///",
  "/// ```dart",
  "/// SvgPicture.asset(",
  "///   AntIconsTwotone.checkCircleTwoTone,",
  "///   package: 'antd_icons_flutter',",
  "/// )",
  "/// ```",
  "///",
  "/// ## 资产加载说明",
  "///",
  "/// SVG 文件随包内 `pubspec.yaml` 的 `assets` 声明整体打包，通过",
  "/// `rootBundle` 按需异步加载；自定义 [AntdIcon.twoToneColor] 时首次渲染",
  "/// 有一帧异步等待，且替换结果会按「路径 + 主色 + 次色」缓存。",
  "///",
  "/// ## Tree-shaking 说明",
  "///",
  "/// 与 [AntIcons]（TTF 整字体打包）不同，SVG 资产按文件粒度进入安装包；",
  "/// 但由于资产以目录形式声明，当前版本为全量打包，不做按引用裁剪。",
];

const FONT_FAMILY = 'AntIcons';
const PACKAGE_NAME = 'antd_icons_flutter';
const CODEPOINT_START = 0xe001;

// ── 参数解析 ──────────────────────────────────────────────
function getArg(flag) {
  const i = process.argv.indexOf(flag);
  return i !== -1 && i + 1 < process.argv.length ? process.argv[i + 1] : null;
}
const hasFlag = (flag) => process.argv.includes(flag);
const TARGET_VERSION = getArg('--version') || 'latest';

// ── 工具函数 ──────────────────────────────────────────────
/** kebab-case → camelCase: "check-circle" → "checkCircle" */
function kebabToCamel(s) {
  return s.replace(/-([a-z0-9])/g, (_, c) => c.toUpperCase());
}

/** 收集目录下全部 .svg 文件名（不含扩展名），排序返回 */
function collectIcons(dir) {
  if (!fs.existsSync(dir)) return [];
  return fs
    .readdirSync(dir)
    .filter((f) => f.endsWith('.svg'))
    .map((f) => f.replace(/\.svg$/, ''))
    .sort();
}

/** 控制台输出标签 */
const log = {
  info: (msg) => console.log(`[信息] ${msg}`),
  ok: (msg) => console.log(`[成功] ${msg}`),
  warn: (msg) => console.log(`[警告] ${msg}`),
  err: (msg) => console.error(`[错误] ${msg}`),
};

// ── 远程下载 + 解压 ──────────────────────────────────────
async function downloadAndExtract() {
  fs.mkdirSync(CACHE_DIR, { recursive: true });

  // 查询版本信息
  const metaUrl = `${NPM_REGISTRY}/${encodeURIComponent(PKG_NAME)}/${TARGET_VERSION}`;
  log.info(`正在查询 ${PKG_NAME}@${TARGET_VERSION} ...`);
  const meta = await fetch(metaUrl).then((r) => {
    if (!r.ok) throw new Error(`registry 返回 ${r.status}: ${r.statusText}`);
    return r.json();
  });
  const version = meta.version;
  const tarballUrl = meta.dist.tarball;
  log.info(`最新版本: ${version}`);

  const extractDir = path.join(CACHE_DIR, `icons-svg-${version}`);
  const svgRoot = path.join(extractDir, 'package', 'inline-svg');

  // 缓存命中则跳过下载
  if (!hasFlag('--clean') && fs.existsSync(svgRoot)) {
    log.info(`缓存命中，跳过下载 (${extractDir})`);
    return { svgRoot, version };
  }

  // 下载 tarball
  const tarballPath = path.join(CACHE_DIR, `icons-svg-${version}.tgz`);
  log.info(`正在下载 ${tarballUrl} ...`);
  const res = await fetch(tarballUrl);
    if (!res.ok) throw new Error(`下载失败: ${res.status}`);
  const buf = Buffer.from(await res.arrayBuffer());
  fs.writeFileSync(tarballPath, buf);
  log.info(`已下载 (${(buf.length / 1024).toFixed(0)} KB)`);

  // 解压（系统 tar，兼容 macOS/Linux/Windows 10+）
  fs.rmSync(extractDir, { recursive: true, force: true });
  fs.mkdirSync(extractDir, { recursive: true });
  execSync(`tar -xzf "${tarballPath}" -C "${extractDir}"`, { stdio: 'pipe' });
  log.ok(`已解压到 ${extractDir}`);

  if (!fs.existsSync(svgRoot)) {
    throw new Error(`未找到 SVG 目录: ${svgRoot}（包结构可能已变更）`);
  }
  return { svgRoot, version };
}

// ── TwoTone SVG 颜色规范化 ────────────────────────────────
/**
 * antd twotone SVG 使用多种浅色（#E6E6E6 / #D9D9D9 / #D8D8D8），
 * 统一规范化为 #E6E6E6（次色），主色 #333 保持不变。
 * 运行时 AntdIcon 组件只需替换 #333 → primaryColor、#E6E6E6 → secondaryColor。
 */
function normalizeTwotoneSvg(content) {
  return content
    .replace(/fill="#D9D9D9"/g, 'fill="#E6E6E6"')
    .replace(/fill="#D8D8D8"/g, 'fill="#E6E6E6"')
    .replace(/<svg(?![^>]*xmlns)/g, '<svg xmlns="http://www.w3.org/2000/svg"');
}

// ── TTF 字体生成（outlined + filled） ────────────────────
async function generateTtf(allIcons) {
  log.info('正在生成 SVG 字体...');
  const fontStream = new SVGIcons2SVGFontStream({
    fontName: FONT_FAMILY,
    fontHeight: 1024,
    normalize: true,
    log: () => {},
  });

  const chunks = [];
  fontStream.on('data', (chunk) => chunks.push(chunk));

  for (const icon of allIcons) {
    const content = fs.readFileSync(icon.file, 'utf-8');
    const glyph = Readable.from([content]);
    glyph.metadata = {
      name: icon.dartName,
      unicode: [String.fromCodePoint(icon.codepoint)],
    };
    fontStream.write(glyph);
  }
  fontStream.end();

  await new Promise((resolve, reject) => {
    fontStream.on('end', resolve);
    fontStream.on('error', reject);
  });

  const svgFont = Buffer.concat(chunks).toString('utf-8');
  log.info(`SVG 字体生成完毕 (${(svgFont.length / 1024).toFixed(1)} KB)`);

  log.info('正在转换为 TTF...');
  const ttf = svg2ttf(svgFont, {
    familyName: FONT_FAMILY,
    subfamilyName: 'Regular',
  });
  const ttfBuf = Buffer.from(ttf.buffer);

  fs.mkdirSync(path.dirname(OUT_FONT), { recursive: true });
  fs.writeFileSync(OUT_FONT, ttfBuf);
  log.ok(`TTF 已写入 fonts/AntIcons.ttf (${(ttfBuf.length / 1024).toFixed(1)} KB)`);
}

// ── TwoTone SVG 资产复制 ──────────────────────────────────
function copyTwotoneAssets(svgRoot) {
  const srcDir = path.join(svgRoot, 'twotone');
  const names = collectIcons(srcDir);
  if (names.length === 0) {
    log.warn('未找到 twotone SVG 文件，跳过');
    return [];
  }

  fs.rmSync(OUT_TWOTONE_DIR, { recursive: true, force: true });
  fs.mkdirSync(OUT_TWOTONE_DIR, { recursive: true });

  for (const name of names) {
    const src = path.join(srcDir, `${name}.svg`);
    const content = normalizeTwotoneSvg(fs.readFileSync(src, 'utf-8'));
    fs.writeFileSync(path.join(OUT_TWOTONE_DIR, `${name}.svg`), content);
  }
  log.ok(`TwoTone SVG 已复制 ${names.length} 个到 assets/twotone/`);
  return names;
}

// ── Dart 常量生成：AntIcons（TTF 码点） ──────────────────
function generateAntIconsDart(allIcons, categories, version) {
  const lines = [];
  lines.push('// 本文件由 tool/generate.mjs 自动生成，请勿手动修改。');
  lines.push(`// 源: @ant-design/icons-svg@${version}`);
  lines.push('');
  lines.push("import 'package:flutter/widgets.dart';");
  lines.push('');
  lines.push(...ANT_ICONS_CLASS_DOC);
  lines.push('abstract final class AntIcons {');

  for (const cat of categories) {
    const icons = allIcons.filter((i) => i.cat === cat.dir);
    const label = cat.dir === 'outlined' ? 'Outlined（线框风格）' : 'Filled（实心风格）';
    lines.push('');
    lines.push(`  // ── ${label} ${icons.length} 个 ──────────────────────────`);
    for (const icon of icons) {
      const hex = '0x' + icon.codepoint.toString(16);
      lines.push('');
      lines.push(`  /// Ant Design \`${icon.baseName}\` icon (${icon.cat}).`);
      lines.push('  ///');
      lines.push(`  /// <img src="https://api.iconify.design/ant-design/${icon.baseName}.svg?color=%23888" width="16" height="16" alt="${icon.baseName}" />`);
      lines.push('  ///');
      lines.push(`  /// antd React: \`${icon.dartName}\``);
      lines.push(`  static const IconData ${icon.dartName} =`);
      lines.push(`      IconData(${hex}, fontFamily: '${FONT_FAMILY}', fontPackage: '${PACKAGE_NAME}');`);
    }
  }

  // ── 枚举列表（供图标选择器/预览页遍历） ──────────────────
  for (const cat of categories) {
    const icons = allIcons.filter((i) => i.cat === cat.dir);
    const listName = cat.dir === 'outlined' ? 'outlinedIcons' : 'filledIcons';
    lines.push('');
    lines.push(`  /// 全部 ${cat.dir} 图标的 (名称, 图标) 枚举列表，共 ${icons.length} 个。`);
    lines.push(`  static const List<(String name, IconData icon)> ${listName} = [`);
    for (const icon of icons) {
      lines.push(`    ('${icon.dartName}', ${icon.dartName}),`);
    }
    lines.push('  ];');
  }

  lines.push('}');

  fs.mkdirSync(path.dirname(OUT_ANT_ICONS), { recursive: true });
  fs.writeFileSync(OUT_ANT_ICONS, lines.join('\n') + '\n');
  log.ok(`AntIcons 常量已写入 lib/src/ant_icons.dart (${allIcons.length} 个)`);
}

// ── Dart 常量生成：AntIconsTwotone（SVG 路径） ───────────
function generateTwotoneDart(names, version) {
  const lines = [];
  lines.push('// 本文件由 tool/generate.mjs 自动生成，请勿手动修改。');
  lines.push(`// 源: @ant-design/icons-svg@${version}`);
  lines.push('');
  lines.push(...TWOTONE_CLASS_DOC);
  lines.push('abstract final class AntIconsTwotone {');

  lines.push('');
  lines.push(`  // ── TwoTone（双色风格） ${names.length} 个 ──────────────────────────`);
  for (const name of names) {
    const dartName = kebabToCamel(name) + 'TwoTone';
    lines.push('');
    lines.push(`  /// Ant Design \`${name}\` icon (twotone).`);
    lines.push('  ///');
    lines.push(`  /// <img src="https://api.iconify.design/ant-design/${name}-twotone.svg?color=%23888" width="16" height="16" alt="${name}" />`);
    lines.push('  ///');
    lines.push(`  /// antd React: \`${dartName}\``);
    lines.push(`  static const String ${dartName} = 'assets/twotone/${name}.svg';`);
  }

  // ── 枚举列表 ──────────────────────────────────────────
  lines.push('');
  lines.push(`  /// 全部 TwoTone 图标的 (名称, 资产路径) 枚举列表，共 ${names.length} 个。`);
  lines.push('  static const List<(String name, String path)> twotoneIcons = [');
  for (const name of names) {
    const dartName = kebabToCamel(name) + 'TwoTone';
    lines.push(`    ('${dartName}', ${dartName}),`);
  }
  lines.push('  ];');

  lines.push('}');

  fs.mkdirSync(path.dirname(OUT_ANT_ICONS_TWOTONE), { recursive: true });
  fs.writeFileSync(OUT_ANT_ICONS_TWOTONE, lines.join('\n') + '\n');
  log.ok(`AntIconsTwotone 常量已写入 lib/src/ant_icons_twotone.dart (${names.length} 个)`);
}

// ── 主流程 ────────────────────────────────────────────────
async function main() {
  console.log('━━━ antd_icons_flutter 图标资源生成 ━━━');

  // Node 版本检查（需要 18+ 的内置 fetch）
  const major = parseInt(process.versions.node.split('.')[0], 10);
  if (major < 18) {
    throw new Error(`需要 Node.js >= 18（当前 ${process.versions.node}），请升级后重试`);
  }

  // 1. 远程下载 + 解压
  const { svgRoot, version } = await downloadAndExtract();

  // 2. 收集 outlined + filled 图标
  const categories = [
    { dir: 'outlined', suffix: 'Outlined' },
    { dir: 'filled', suffix: 'Filled' },
  ];
  const allIcons = [];
  let codepoint = CODEPOINT_START;
  for (const cat of categories) {
    const names = collectIcons(path.join(svgRoot, cat.dir));
    for (const name of names) {
      allIcons.push({
        file: path.join(svgRoot, cat.dir, `${name}.svg`),
        dartName: kebabToCamel(name) + cat.suffix,
        cat: cat.dir,
        baseName: name,
        codepoint: codepoint++,
      });
    }
  }
  log.info(`共收集 ${allIcons.length} 个图标 (outlined + filled)`);

  // 3. 生成 TTF 字体
  await generateTtf(allIcons);

  // 4. 复制 TwoTone SVG 资产
  const twotoneNames = copyTwotoneAssets(svgRoot);

  // 5. 生成 Dart 常量
  generateAntIconsDart(allIcons, categories, version);
  generateTwotoneDart(twotoneNames, version);

  console.log('━━━ 全部生成完毕 ━━━');
}

main().catch((err) => {
  log.err(err.message || err);
  process.exit(1);
});