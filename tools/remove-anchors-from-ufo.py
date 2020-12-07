import sys
from defcon import Font

if len(sys.argv) < 3:
    sys.exit("expected ufo path and list of anchors to remove")

in_path = sys.argv[1]
anchors = sys.argv[2:]

print("Removing anchors '%s' in file '%s'" % (", ".join(anchors), in_path))

font = Font(in_path)
for g in font:
    before = set(g.name for g in g.anchors)
    g.anchors = [a for a in g.anchors if a.name not in anchors]
    if len(g.anchors) != len(before):
        now = set(a.name for a in g.anchors)
        removed = before.difference(now)
        print("Removed anchors '%s' from glyph '%s'" % (", ".join(removed), g.name))
font.save()
