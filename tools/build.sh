# set -x

MASTERS="sources/masters"
INSTANCES="sources/instances"
FONTS="fonts"

rm -r $MASTERS
rm -r $INSTANCES
rm -r $FONTS

# Extract UFOs from the glyphs sources
fontmake -g sources/Rasa-MM.glyphs -o ufo --interpolate --master-dir=$MASTERS --instance-dir=$INSTANCES
# fontmake -g "sources/Rasa Italics-MM.glyphs" --interpolate --master-dir=$MASTERS --instance-dir=$INSTANCES


# "Upright" instances
# Note grep "-v" means anything "not" matching
for file in $(ls $INSTANCES | grep -v "Italic" ); do
    # Compile the features into the UFOs
    echo "Write upright features to $INSTANCES/$file"

    # Make sure mark features get written without any "design" anchors left over
    python tools/remove-anchors-from-ufo.py $INSTANCES/$file periodcentred _periodcentred

    # Combine and write our custom features to the UFOs
    python tools/parse-features.py production/features/uprights.fea $INSTANCES/$file

    # Compile OTF fonts
    fontmake -u $INSTANCES/$file --output otf --output-dir $FONTS --debug-feature-file debug.fea

    gftools fix-dsig --autofix master_otf/${file/ufo/otf}
done

# "Italic" instances
# for file in $(ls $INSTANCES | grep "Italic"); do
# done
