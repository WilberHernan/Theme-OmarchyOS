#!/usr/bin/env python3
"""Minimal xcursorgen — reads .cursor files + PNGs, writes XCursor binary."""
import struct, os
from pathlib import Path
from PIL import Image

def png_to_chunk(png_path, xhot, yhot, delay=0):
    img = Image.open(png_path).convert("RGBA")
    w, h = img.size
    pixels = bytearray()
    for y in range(h):
        for x in range(w):
            r, g, b, a = img.getpixel((x, y))
            pixels += struct.pack(">BBBB", a, r, g, b)
    data_len = len(pixels)
    chunk = struct.pack(">IIIIIIIIII", 0xfffe0001, 36, 1, 0, w, h, xhot, yhot, delay, data_len)
    return chunk + bytes(pixels)

def write_xcursor(path, frames):
    chunks = b""
    for size, xhot, yhot, png, delay in frames:
        chunks += png_to_chunk(png, xhot, yhot, delay)

    toc_entries = b""
    for size, xhot, yhot, png, delay in frames:
        toc_entries += struct.pack(">III", 0xfffe0001, size, 36)

    ntoc = len(frames)
    file_hdr = struct.pack(">IIII", 0x58437572, 16, 1, ntoc)
    with open(path, "wb") as f:
        f.write(file_hdr + chunks)

source = Path("/tmp/oxy-cursor/oxy-neon-white/source")
out = Path("/tmp/oxy-cursor/oxy-neon-white/cursors")
out.mkdir(exist_ok=True)

for cfg in sorted(source.glob("*.cursor")):
    name = cfg.stem
    lines = cfg.read_text().strip().splitlines()
    frames = []
    for line in lines:
        parts = line.split()
        if len(parts) < 4:
            continue
        size, xhot, yhot = int(parts[0]), int(parts[1]), int(parts[2])
        png = parts[3]
        png_path = source / png
        if not png_path.exists():
            continue
        delay = int(parts[4]) if len(parts) > 4 else 50
        frames.append((size, xhot, yhot, png_path, delay))
    if not frames:
        continue
    dst = out / name
    write_xcursor(dst, frames)
    print(f"  ok  {name} ({len(frames)} frame(s))")
