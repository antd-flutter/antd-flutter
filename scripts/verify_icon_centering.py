#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""verify_icon_centering.py — 校验 example 图标产物内容居中。

对每个 png 计算"与白底差异"内容 bbox，其中心与画布中心偏差应 ≤ 2px
（允许整数取整误差）；.ico 则逐档解析内置尺寸校验。

用法：python3 scripts/verify_icon_centering.py <example路径> [<example路径>...]
"""
import os
import sys

from PIL import Image, ImageChops

TOLERANCE = 2.0


def content_bbox(im, bg_rgb=(255, 255, 255)):
    rgb = im.convert("RGB")
    diff = ImageChops.difference(rgb, Image.new("RGB", rgb.size, bg_rgb)).convert("L")
    return diff.point(lambda x: 255 if x > 10 else 0).getbbox()


def check_image(path):
    im = Image.open(path).convert("RGBA")
    bbox = content_bbox(im)
    if bbox is None:
        return path, None, "无内容"
    ox = abs((bbox[0] + bbox[2]) / 2 - im.width / 2)
    oy = abs((bbox[1] + bbox[3]) / 2 - im.height / 2)
    passed = ox <= TOLERANCE and oy <= TOLERANCE
    return path, (round(ox, 1), round(oy, 1)), ("OK" if passed else "FAIL")


def check_ico(path):
    results = []
    img = Image.open(path)
    for size in sorted(img.ico.sizes()):
        img.size = size
        frame = img.convert("RGBA")
        bbox = content_bbox(frame)
        size = frame.size
        if bbox is None:
            results.append((size, None, "无内容"))
            continue
        ox = abs((bbox[0] + bbox[2]) / 2 - frame.width / 2)
        oy = abs((bbox[1] + bbox[3]) / 2 - frame.height / 2)
        passed = ox <= TOLERANCE and oy <= TOLERANCE
        results.append((size, (round(ox, 1), round(oy, 1)), "OK" if passed else "FAIL"))
    return results


def main():
    fails = 0
    for example in sys.argv[1:]:
        print(f"== {example} ==")
        targets = []
        and_res = os.path.join(example, "android/app/src/main/res")
        if os.path.isdir(and_res):
            for d in sorted(os.listdir(and_res)):
                if d.startswith("mipmap-"):
                    targets.append(os.path.join(and_res, d, "ic_launcher.png"))
        for base in ("ios/Runner/Assets.xcassets/AppIcon.appiconset",
                     "macos/Runner/Assets.xcassets/AppIcon.appiconset"):
            d = os.path.join(example, base)
            if os.path.isdir(d):
                targets += [os.path.join(d, f) for f in sorted(os.listdir(d)) if f.endswith(".png")]
        web = os.path.join(example, "web")
        for rel in ("favicon.png", "icons/Icon-192.png", "icons/Icon-512.png",
                    "icons/Icon-maskable-192.png", "icons/Icon-maskable-512.png"):
            p = os.path.join(web, rel)
            if os.path.exists(p):
                targets.append(p)
        ico = os.path.join(example, "windows/runner/resources/app_icon.ico")
        for p in targets:
            path, off, status = check_image(p)
            print(f"  {os.path.relpath(path, example):60s} offset={off} {status}")
            if status == "FAIL":
                fails += 1
        if os.path.exists(ico):
            for size, off, status in check_ico(ico):
                print(f"  windows/runner/resources/app_icon.ico {size[0]}x{size[1]:<18} offset={off} {status}")
                if status == "FAIL":
                    fails += 1
    if fails:
        print(f"[失败] {fails} 档居中偏差超限")
        sys.exit(1)
    print("[OK] 全部图标内容居中（偏差 ≤ 2px）")


if __name__ == "__main__":
    main()
