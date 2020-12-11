import sys
import os
import re
from fontTools.feaLib.parser import Parser
from fontTools.feaLib.ast import FeatureFile
from ufo2ft.featureWriters.markFeatureWriter import MarkFeatureWriter
from defcon import Font

if len(sys.argv) not in [3, 4]:
    sys.exit("parse-features.py expected exactly 2 arguments, input and "
             "output feature files and 1 optional argument with style name "
             "being processed for replacing that string in the feature file.")

in_path = sys.argv[1]
out_path = sys.argv[2]
if len(sys.argv) == 4:
    stylename = sys.argv[3]
else:
    # e.g. "Bold" in "sources/masters/Rasa-Bold.ufo"
    stylename = re.search(r"Rasa\-([A-z]+)", out_path).group(1)

features = ""

# Generate markClass statements and prepend them
font = Font(out_path)
markClassDefinitions = []
feaFile = FeatureFile()  # A holder for the generated mark features

markWriter = MarkFeatureWriter()
markWriter.write(font, feaFile)
markFeatures = feaFile.asFea()  # Get the generated mark features

reMarkClass = re.compile(r"markClass.*;")
markClassDefinitions = reMarkClass.findall(
    markFeatures)  # Save all the markClass definitions

# Read the input feature file
with open(in_path, "r") as input_fea:
    # Replace $markClasses with the generated markClassDefinitions
    if markClassDefinitions != []:
        features = input_fea.read().replace(
            "$markClasses", "\n".join(markClassDefinitions))
    else:
        features = input_fea.read().replace("$markClasses", "")

    if stylename:
        # Replace the matra I style-based include path for each style
        print("Replacing $stylename with '%s' if found in feature file" %
              stylename)
        features = features.replace("$stylename", stylename)

    # Write to a temporary file, which we can parse and expand all includes
    with open("production/features/tmp.fea", "w") as tmp:
        tmp.write(features)

parser = Parser("production/features/tmp.fea")
parsed = parser.parse()
os.remove("production/features/tmp.fea")

# Write the parsed and substituted features to the UFO features
with open(out_path + "/features.fea", "w") as fea:
    fea.write(str(parsed))
