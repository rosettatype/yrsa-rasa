import sys
import os
import re
from fontTools.feaLib.parser import Parser
from fontTools.feaLib.ast import FeatureFile
from ufo2ft.featureWriters.markFeatureWriter import MarkFeatureWriter
from defcon import Font

if len(sys.argv) != 3:
    sys.exit("parse-features.py expected exactly 2 arguments, input and output feature files.")

in_path = sys.argv[1]
out_path = sys.argv[2]
stylename = re.search(r"Rasa\-([A-z]+)", out_path).group(1)  # e.g. "Bold" in "sources/masters/Rasa-Bold.ufo"

features = ""

# Generate markClass statements and prepend them
font = Font(out_path)
markClassDefinitions = []
feaFile = FeatureFile()  # A holder for the generated mark features

markWriter = MarkFeatureWriter()
markWriter.write(font, feaFile)
markFeatures = feaFile.asFea()  # Get the generated mark features

reMarkClass = re.compile(r"markClass.*;")
markClassDefinitions = reMarkClass.findall(markFeatures)  # Save all the markClass definitions

# Read the input feature file
with open(in_path, "r") as input_fea:
    # Replace $markClasses with the generated markClassDefinitions
    if markClassDefinitions != []:
        features = input_fea.read().replace("$markClasses", "\n".join(markClassDefinitions))
    else:
        features = input_fea.read().replace("$markClasses", "")

    # Replace the matra I style-based include path for each style
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
