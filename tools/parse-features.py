import sys
from fontTools.feaLib.parser import Parser

if len(sys.argv) != 3:
    sys.exit("parse-features.py expected exactly 2 arguments, input and output feature files.")

in_path = sys.argv[1]
out_path = sys.argv[2]

parser = Parser(in_path)
parsed = parser.parse()

with open(out_path, "w") as fea:
    fea.write(str(parsed))
