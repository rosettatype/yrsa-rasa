__doc__ = """
    Script to replace a string in font name tables

    Changes names in IDs 1, 3, 4, 6 and 16 if set.

    USAGE

    From the command line or a shell script, run:

    python SCRIPT/PATH/replace-family-name.py [FONT/PATH/font.ttf] [Old String] [New String]
"""

from fontTools.ttLib import TTFont

import sys
import os

# ---------------------------------------------------------------------
# capture args from command line cue ----------------------------------
filePath = sys.argv[1]
newFamilyName = sys.argv[3]
oldFamilyName = sys.argv[2]

print("Replace '%s' with '%s' in name tables." %
      (oldFamilyName, newFamilyName))

fileName = os.path.basename(filePath)

f = TTFont(filePath)
for id in [1, 3, 4, 6, 16]:
    name = f["name"].getDebugName(id)
    old = oldFamilyName
    newFam = newFamilyName
    if not name:
        continue

    if id in [3, 6]:
        # No spaces in these name tables
        old = oldFamilyName.replace(" ", "")
        newFam = newFamilyName.replace(" ", "")

    newName = name.replace(old, newFam)
    f["name"].setName(newName, id, 3, 1, 0x409)
    print("replaced name ID %d '%s' with '%s'" % (id, name, newName))
f.save(filePath)
