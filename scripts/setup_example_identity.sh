#!/usr/bin/env bash
# =============================================================================
# setup_example_identity.sh — Flutter example 图标/应用名统一脚本（macOS）
#
# 功能：按 R32.2 规范（docs/plan/PLAN.md）为指定 example 一键完成全端
#       图标替换与应用名设置：
#         - 统一图标源：https://gw.alipayobjects.com/zos/rmsportal/KDpgvguMpGfqaHPjicRK.svg
#         - Android : mipmap 五档 ic_launcher.png + AndroidManifest android:label
#         - iOS     : AppIcon.appiconset 全尺寸 PNG（按 Contents.json 清单）+ CFBundleDisplayName
#         - macOS   : AppIcon.appiconset app_icon_*.png（按 Contents.json 清单）+ CFBundleName
#         - web     : favicon.png + icons/Icon-192/512 + maskable + manifest.json name/short_name
#
# 用法：
#   bash scripts/setup_example_identity.sh --pkg antd_qrcode \
#       --example packages/antd_qrcode/example --name AntdQrcode [--svg <svg路径>]
#
# 说明：
#   - SVG 本地缓存于 .temp/brand/icon.svg，避免重复下载
#   - SVG→PNG：qlmanage 栅格化 1024 母图 + Pillow 归一化/缩放
#   - 幂等：重复执行安全，只改图标与应用名相关文件
#   - Windows 适配（.bat/.ps1 三件套）由后续统一任务处理，本脚本当前仅支持 macOS bash
# =============================================================================
set -euo pipefail

BRAND_SVG_URL="https://gw.alipayobjects.com/zos/rmsportal/KDpgvguMpGfqaHPjicRK.svg"
BRAND_CACHE=".temp/brand/icon.svg"
RENDER_DIR=".temp/brand/render"
MASTER_PNG="$RENDER_DIR/master_1024.png"

PKG=""
EXAMPLE=""
NAME=""
SVG=""

info() { echo "[信息] $*"; }
ok()   { echo "[完成] $*"; }
err()  { echo "[错误] $*" >&2; exit 1; }

usage() {
  sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --pkg)     PKG="$2"; shift 2 ;;
    --example) EXAMPLE="$2"; shift 2 ;;
    --name)    NAME="$2"; shift 2 ;;
    --svg)     SVG="$2"; shift 2 ;;
    -h|--help) usage ;;
    *) err "未知参数：$1（--help 查看用法）" ;;
  esac
done

[[ -n "$PKG" ]]     || err "缺少 --pkg <包名>"
[[ -n "$EXAMPLE" ]] || err "缺少 --example <example路径>"
[[ -n "$NAME" ]]    || err "缺少 --name <大驼峰显示名>"
[[ -d "$EXAMPLE" ]] || err "example 路径不存在：$EXAMPLE"

command -v curl     >/dev/null || err "未找到 curl"
command -v qlmanage >/dev/null || err "未找到 qlmanage（macOS 自带）"
command -v python3  >/dev/null || err "未找到 python3"
python3 -c 'import PIL' >/dev/null 2>&1 || err "python3 缺少 Pillow（pip3 install pillow）"

info "目标：pkg=$PKG example=$EXAMPLE name=$NAME"

mkdir -p .temp/brand

# ---------- 1. SVG 获取（本地缓存） ----------
if [[ -n "$SVG" ]]; then
  [[ -f "$SVG" ]] || err "指定的 svg 不存在：$SVG"
  cp "$SVG" "$BRAND_CACHE"
  info "使用本地 SVG：$SVG"
elif [[ -f "$BRAND_CACHE" ]]; then
  info "复用缓存 SVG：$BRAND_CACHE"
else
  curl -fsSL "$BRAND_SVG_URL" -o "$BRAND_CACHE"
  info "下载统一图标 SVG → $BRAND_CACHE"
fi

# ---------- 2. SVG → PNG（qlmanage 栅格化 + Pillow 归一化母图） ----------
rm -rf "$RENDER_DIR"
mkdir -p "$RENDER_DIR"
qlmanage -t -s 1024 -o "$RENDER_DIR" "$BRAND_CACHE" >/dev/null 2>&1
RAW_PNG="$RENDER_DIR/$(basename "$BRAND_CACHE").png"
[[ -f "$RAW_PNG" ]] || err "qlmanage 栅格化失败：未生成 $RAW_PNG"

python3 - "$RAW_PNG" "$MASTER_PNG" <<'PY'
import sys
from PIL import Image, ImageChops
raw, master = sys.argv[1], sys.argv[2]
img = Image.open(raw).convert("RGBA")
# qlmanage 输出为不透明白底（alpha 全 255），getbbox() 无法定位内容；
# 改用与白底的差异检测内容 bbox，裁掉空白边缘后居中到方形画布
diff = ImageChops.difference(img.convert("RGB"), Image.new("RGB", img.size, (255, 255, 255)))
bbox = diff.convert("L").point(lambda x: 255 if x > 10 else 0).getbbox()
if bbox:
    img = img.crop(bbox)
side = max(img.size)
canvas = Image.new("RGBA", (side, side), (0, 0, 0, 0))
canvas.paste(img, ((side - img.width) // 2, (side - img.height) // 2))
canvas = canvas.resize((1024, 1024), Image.LANCZOS)
# 自检：非白内容 bbox 中心与画布中心偏差 ≤ 2px
rgb = canvas.convert("RGB")
d2 = ImageChops.difference(rgb, Image.new("RGB", rgb.size, (255, 255, 255))).convert("L")
b2 = d2.point(lambda x: 255 if x > 10 else 0).getbbox()
if b2:
    ox = abs((b2[0] + b2[2]) / 2 - 512)
    oy = abs((b2[1] + b2[3]) / 2 - 512)
    if ox > 2 or oy > 2:
        sys.exit(f"[错误] 母图内容未居中：偏差 ({ox:.1f}, {oy:.1f})px > 2px")
canvas.save(master)
PY
ok "生成 1024 母图 → $MASTER_PNG"

# ---------- 3-6. 各端图标 + 名称 ----------
python3 - "$EXAMPLE" "$NAME" "$MASTER_PNG" <<'PY'
import json, os, plistlib, re, sys
from PIL import Image

example, name, master_path = sys.argv[1], sys.argv[2], sys.argv[3]
master = Image.open(master_path).convert("RGBA")
changed = []

def write_png(path, size):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    img = master.resize((size, size), Image.LANCZOS)
    img.save(path, optimize=True)
    changed.append((path, size))

# ---- Android：mipmap 五档 ----
and_res = os.path.join(example, "android/app/src/main/res")
density = {"mdpi": 48, "hdpi": 72, "xhdpi": 96, "xxhdpi": 144, "xxxhdpi": 192}
for d, size in density.items():
    p = os.path.join(and_res, f"mipmap-{d}", "ic_launcher.png")
    if os.path.exists(p):
        write_png(p, size)

# ---- Android：AndroidManifest android:label ----
manifest = os.path.join(example, "android/app/src/main/AndroidManifest.xml")
if os.path.exists(manifest):
    text = open(manifest, encoding="utf-8").read()
    new = re.sub(r'(<application[^>]*\bandroid:label=")[^"]*(")',
                 rf'\g<1>{name}\g<2>', text, count=1, flags=re.S)
    if new != text:
        open(manifest, "w", encoding="utf-8").write(new)
        changed.append((manifest, None))

# ---- 按 Contents.json 清单替换 appiconset PNG（iOS / macOS 通用） ----
def update_appiconset(base):
    cj = os.path.join(base, "Contents.json")
    if not os.path.exists(cj):
        return
    data = json.load(open(cj, encoding="utf-8"))
    for entry in data["images"]:
        fn = entry.get("filename")
        if not fn:
            continue
        size = float(entry["size"].split("x")[0]) * float(entry.get("scale", "1x")[:-1])
        write_png(os.path.join(base, fn), int(round(size)))

update_appiconset(os.path.join(example, "ios/Runner/Assets.xcassets/AppIcon.appiconset"))
update_appiconset(os.path.join(example, "macos/Runner/Assets.xcassets/AppIcon.appiconset"))

# ---- iOS：CFBundleDisplayName ----
ios_plist = os.path.join(example, "ios/Runner/Info.plist")
if os.path.exists(ios_plist):
    with open(ios_plist, "rb") as f:
        pl = plistlib.load(f)
    if pl.get("CFBundleDisplayName") != name:
        pl["CFBundleDisplayName"] = name
        with open(ios_plist, "wb") as f:
            plistlib.dump(pl, f)
        changed.append((ios_plist, None))

# ---- macOS：CFBundleName ----
mac_plist = os.path.join(example, "macos/Runner/Info.plist")
if os.path.exists(mac_plist):
    with open(mac_plist, "rb") as f:
        pl = plistlib.load(f)
    if pl.get("CFBundleName") != name:
        pl["CFBundleName"] = name
        with open(mac_plist, "wb") as f:
            plistlib.dump(pl, f)
        changed.append((mac_plist, None))

# ---- web：favicon + icons + manifest ----
web = os.path.join(example, "web")
if os.path.isdir(web):
    for rel, size in [("favicon.png", 16), ("icons/Icon-192.png", 192),
                      ("icons/Icon-512.png", 512), ("icons/Icon-maskable-192.png", 192),
                      ("icons/Icon-maskable-512.png", 512)]:
        p = os.path.join(web, rel)
        if os.path.exists(p):
            write_png(p, size)
    mf = os.path.join(web, "manifest.json")
    if os.path.exists(mf):
        data = json.load(open(mf, encoding="utf-8"))
        dirty = False
        for k in ("name", "short_name"):
            if data.get(k) != name:
                data[k] = name
                dirty = True
        if dirty:
            with open(mf, "w", encoding="utf-8") as f:
                json.dump(data, f, ensure_ascii=False, indent=4)
                f.write("\n")
            changed.append((mf, None))

# ---- Windows：app_icon.ico + Runner.rc + 窗口标题 ----
win_res = os.path.join(example, "windows/runner")
ico = os.path.join(win_res, "resources/app_icon.ico")
if os.path.exists(ico):
    master.save(ico, sizes=[(16, 16), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)])
    changed.append((ico, "ico"))
rc = os.path.join(win_res, "Runner.rc")
if os.path.exists(rc):
    text = open(rc, encoding="utf-8").read()
    new = re.sub(r'(VALUE "(?:FileDescription|ProductName)", ")[^"]*(")',
                 rf'\g<1>{name}\g<2>', text)
    if new != text:
        open(rc, "w", encoding="utf-8").write(new)
        changed.append((rc, None))
main_cpp = os.path.join(win_res, "main.cpp")
if os.path.exists(main_cpp):
    text = open(main_cpp, encoding="utf-8").read()
    new = re.sub(r'(\.Create\(L")[^"]*(")', rf'\g<1>{name}\g<2>', text)
    if new != text:
        open(main_cpp, "w", encoding="utf-8").write(new)
        changed.append((main_cpp, None))

# ---- Linux：gtk 窗口标题 ----
linux_cc = os.path.join(example, "linux/runner/my_application.cc")
if os.path.exists(linux_cc):
    text = open(linux_cc, encoding="utf-8").read()
    new = re.sub(r'(gtk_window_set_title\(window, ")[^"]*(")',
                 rf'\g<1>{name}\g<2>', text)
    if new != text:
        open(linux_cc, "w", encoding="utf-8").write(new)
        changed.append((linux_cc, None))

for path, size in changed:
    print(f"  {path}" + (f" ({size}x{size})" if size else ""))
print(f"共更新 {len(changed)} 项")
PY

ok "setup_example_identity 完成：${EXAMPLE}（${NAME}）"
