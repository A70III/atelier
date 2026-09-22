#!/usr/bin/env python3
"""Measure WCAG contrast ratios for foreground and background colour pairs.

Usage:
    scripts/contrast.py <fg> <bg> [<fg2> <bg2> ...] [options]

Colours are hex, with or without the leading '#', in 3- or 6-digit form:
    scripts/contrast.py "#1E293B" "#F8FAFC"
    scripts/contrast.py 1e293b f8fafc
    scripts/contrast.py "#0F172A" "#F8FAFC" --size 14
    scripts/contrast.py "#FFF" "#000" --json

Options:
    --size PX   Text size in CSS pixels. 24 or above counts as large text.
    --bold      Combined with --size, 18.66px or above counts as large text.
    --large     Treat every pair as large text (3:1 threshold).
    --aaa       Require the 7:1 threshold for the verdict as well.
    --json      Machine-readable output.
    -h, --help  Show this help.

Exit codes:
    0  every pair clears the threshold that applies to it
    1  at least one pair fails
    2  bad arguments or an unreadable colour
"""

from __future__ import annotations

import json
import re
import sys

HEX = re.compile(r"^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$")


def parse_hex(value: str) -> tuple[int, int, int]:
    match = HEX.match(value.strip())
    if not match:
        raise ValueError(f"not a hex colour: {value!r}")
    digits = match.group(1)
    if len(digits) == 3:
        digits = "".join(ch * 2 for ch in digits)
    return (int(digits[0:2], 16), int(digits[2:4], 16), int(digits[4:6], 16))


def _channel(value: int) -> float:
    srgb = value / 255.0
    return srgb / 12.92 if srgb <= 0.04045 else ((srgb + 0.055) / 1.055) ** 2.4


def relative_luminance(rgb: tuple[int, int, int]) -> float:
    r, g, b = (_channel(c) for c in rgb)
    return 0.2126 * r + 0.7152 * g + 0.0722 * b


def contrast_ratio(fg: tuple[int, int, int], bg: tuple[int, int, int]) -> float:
    l1, l2 = relative_luminance(fg), relative_luminance(bg)
    lighter, darker = max(l1, l2), min(l1, l2)
    return (lighter + 0.05) / (darker + 0.05)


def is_large(size: float | None, bold: bool) -> bool:
    if size is None:
        return False
    if size >= 24:
        return True
    return bold and size >= 18.66


def main(argv: list[str]) -> int:
    args: list[str] = []
    size: float | None = None
    bold = False
    force_large = False
    require_aaa = False
    as_json = False

    i = 0
    while i < len(argv):
        arg = argv[i]
        if arg in ("-h", "--help"):
            print(__doc__.strip())
            return 0
        if arg == "--size":
            i += 1
            if i >= len(argv):
                print("--size needs a number", file=sys.stderr)
                return 2
            try:
                size = float(argv[i])
            except ValueError:
                print(f"--size needs a number, got {argv[i]!r}", file=sys.stderr)
                return 2
        elif arg == "--bold":
            bold = True
        elif arg == "--large":
            force_large = True
        elif arg == "--aaa":
            require_aaa = True
        elif arg == "--json":
            as_json = True
        elif arg.startswith("-"):
            print(f"unknown option: {arg}", file=sys.stderr)
            return 2
        else:
            args.append(arg)
        i += 1

    if len(args) < 2 or len(args) % 2 != 0:
        print(
            "usage: contrast.py <fg> <bg> [<fg2> <bg2> ...] [--size PX] [--bold] [--large] [--json]",
            file=sys.stderr,
        )
        return 2

    large = force_large or is_large(size, bold)
    threshold = 3.0 if large else 4.5

    results = []
    failed = 0

    for index in range(0, len(args), 2):
        fg_raw, bg_raw = args[index], args[index + 1]
        try:
            fg, bg = parse_hex(fg_raw), parse_hex(bg_raw)
        except ValueError as exc:
            print(str(exc), file=sys.stderr)
            return 2

        ratio = contrast_ratio(fg, bg)
        aa = ratio >= threshold
        aaa = ratio >= 7.0
        nontext = ratio >= 3.0
        verdict_ok = aa and (aaa if require_aaa else True)
        if not verdict_ok:
            failed += 1

        results.append(
            {
                "fg": fg_raw,
                "bg": bg_raw,
                "ratio": round(ratio, 2),
                "text_kind": "large" if large else "normal",
                "threshold": threshold,
                "aa": aa,
                "aaa": aaa,
                "nontext_3to1": nontext,
                "pass": verdict_ok,
            }
        )

    if as_json:
        print(json.dumps({"large_text": large, "results": results}, indent=2))
    else:
        print(f"WCAG contrast, {'large' if large else 'normal'} text, threshold {threshold}:1")
        print("-" * 58)
        for row in results:
            mark = "PASS" if row["pass"] else "FAIL"
            print(
                f"{mark}  {row['fg']} on {row['bg']}  "
                f"ratio {row['ratio']}:1  "
                f"AA {yesno(row['aa'])}  AAA {yesno(row['aaa'])}  "
                f"non-text 3:1 {yesno(row['nontext_3to1'])}"
            )
        if failed:
            print("-" * 58)
            print(f"{failed} pair(s) fail the {threshold}:1 threshold. Fix them, or confirm the pair is decorative.")
        else:
            print("-" * 58)
            print("All pairs clear their threshold.")

    return 1 if failed else 0


def yesno(value: bool) -> str:
    return "yes" if value else "no"


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
