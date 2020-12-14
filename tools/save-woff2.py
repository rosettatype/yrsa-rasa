"""
A simple convenience script to compress WOFF2 files
"""
import sys
from fontTools.ttLib.woff2 import compress
if len(sys.argv) != 3:
    exit("Expecting exactly two arguments, input path (ttf) and output path (woff2)")

in_path = sys.argv[1]
out_path = sys.argv[2]

compress(in_path, out_path)
