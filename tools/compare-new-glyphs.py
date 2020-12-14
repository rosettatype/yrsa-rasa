"""
Helper script to compare the previously GF-published Rasa with the current to
check which encoded glyphs got added
"""
import unicodedata2
from fontTools.ttLib import TTFont

before = TTFont("tests/Rasa-Regular-GF-2020-12.ttf")
now = TTFont("fonts/Rasa/Rasa-Regular.ttf")

before_unicodes = set(before["cmap"].getBestCmap().keys())
now_unicodes = set(now["cmap"].getBestCmap().keys())
new = sorted(now_unicodes.difference(before_unicodes))

for n in new:
    print("%s # %s (%s)" % ("U+" + f"{n:04X}", now["cmap"].getBestCmap()[n], unicodedata2.name(chr(n))))
