# set -x

MASTERS="sources/masters"
INSTANCES="sources/instances"
FONTS="fonts"

rm -r $MASTERS
rm -r $INSTANCES
rm -r $FONTS

# Extract UFOs from the glyphs sources
echo "Extracting UFOs from Glyph sources"
fontmake -g sources/Rasa-MM.glyphs -o ufo --interpolate --master-dir=$MASTERS --instance-dir=$INSTANCES
fontmake -g "sources/Rasa Italics-MM.glyphs" -o ufo --interpolate --master-dir=$MASTERS --instance-dir=$INSTANCES

# Loop through the instances and prepare and compile each of them
for file in $(ls $INSTANCES); do

    echo "Preparing $INSTANCES/$file"
    # Make sure mark features get written without any "design" anchors left over
    python tools/remove-anchors-from-ufo.py $INSTANCES/$file periodcentred _periodcentred


    echo "Write upright features to $INSTANCES/$file"
    # Combine and write our custom features to the UFOs
    if [[ "$file" == *Italic.ufo* ]]; then
        python tools/parse-features.py production/features/italics.fea $INSTANCES/$file
    else
        python tools/parse-features.py production/features/uprights.fea $INSTANCES/$file
    fi


    echo "Compiling $FONTS/${file/ufo/ttf}"
    # Compile OTF fonts
    fontmake -u $INSTANCES/$file --output ttf --output-dir $FONTS --debug-feature-file debug.fea

    gftools fix-dsig --autofix $FONTS/${file/ufo/ttf}
done
