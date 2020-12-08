# The build script for Rasa/Yrsa fonts
#
# Usage:
# - To build all fonts: ./tools/build.sh
# Arguments:
# -u: Extract UFOs from sources
# -f Rasa/-f Yrsa: Build only the full family (Rasa) or the Latin subset (Yrsa)
# -t/-o: Build only TTF/OTF files
# -i: Build instance files
# -v: Build variable font files
#
MASTERS="sources/masters"
INSTANCES="sources/instances"
FONTS="fonts"

TTF=0
OTF=0
STATIC=0
VF=0
WOFF=0

while getopts "ivtowuf:" opt
do
	case "${opt}" in
        i) STATIC=1;;
        v) VF=1;;
		t) TTF=1;;
		o) OTF=1;;
        w) WOFF=1;;
        u) UFO=1;;
        f) FAMILY=$OPTARG;;
	esac
done

# Fall back to use ttf if no format was specified
if [ $TTF == 0 ] && [ $OTF == 0 ]; then
    TTF=1
    OTF=1
fi

# Fall back to compile both, statics and variable fonts
if [ $STATIC == 0 ] && [ $VF == 0 ]; then
    STATIC=1
    VF=1
fi

# Output family: Rasa, Yrsa, or both
case $FAMILY in
    Yrsa) YRSA=1;;
    Rasa) RASA=1;;
    *) YRSA=1 RASA=1;;
esac


if [ $UFO ]; then
    rm -r $MASTERS
    rm -r $INSTANCES

    # Extract UFOs from the glyphs sources
    echo "Extracting UFOs from Glyph sources"
    fontmake -g sources/Rasa-MM.glyphs -o ufo --interpolate --master-dir=$MASTERS --instance-dir=$INSTANCES
    fontmake -g "sources/Rasa Italics-MM.glyphs" -o ufo --interpolate --master-dir=$MASTERS --instance-dir=$INSTANCES
fi


if [ $STATIC ]; then
    echo ""
    echo "Compiling instances"

    # Loop through the instances and prepare and compile each of them
    for ufo in $(ls $INSTANCES); do

        # Make sure mark features get written without any "design" anchors left over
        echo "Preparing $INSTANCES/$ufo"
        python tools/remove-anchors-from-ufo.py $INSTANCES/$ufo periodcentred _periodcentred


        if [ $RASA ]; then
            # Combine and write our custom features to the UFOs
            echo "Write features to $INSTANCES/$ufo"
            if [[ "$ufo" == *Italic.ufo* ]]; then
                python tools/parse-features.py production/features/italics.fea $INSTANCES/$ufo
            else
                python tools/parse-features.py production/features/uprights-rasa.fea $INSTANCES/$ufo
            fi


            if [ $TTF ]; then
                font=${ufo/ufo/ttf}
                rm $FONTS/$font

                echo "Compiling $FONTS/$font"
                fontmake -u $INSTANCES/$ufo --output ttf --output-path $FONTS/$font

                echo "Autohinting $FONTS/$font"
                ttfautohint $FONTS/$font $FONTS/$font-hinted
                cp $FONTS/$font-hinted $FONTS/$font
                rm $FONTS/$font-hinted
                
                gftools fix-dsig --autofix $FONTS/$font
            fi


            if [ $OTF ]; then
                font=${ufo/ufo/otf}
                rm $FONTS/$font

                echo "Compiling $FONTS/$font"
                fontmake -u $INSTANCES/$ufo --output otf --output-path $FONTS/$font
                
                gftools fix-dsig --autofix $FONTS/$font
            fi
        fi


        if [ $YRSA ]; then
            # Combine and write our custom features to the UFOs
            echo "Write features to $INSTANCES/$ufo"
            if [[ "$ufo" == *Italic.ufo* ]]; then
                python tools/parse-features.py production/features/italics.fea $INSTANCES/$ufo
            else
                python tools/parse-features.py production/features/uprights-yrsa.fea $INSTANCES/$ufo
            fi

            if [ $TTF ]; then
                echo "Compiling $FONTS/${ufo/ufo/ttf}"
                font=${ufo/ufo/ttf}
                font=${font/Rasa/Yrsa}
                rm $FONTS/$font
                fontmake -u $INSTANCES/$ufo --output ttf --output-path $FONTS/$font

                echo "Autohinting $FONTS/$font"
                ttfautohint $FONTS/$font $FONTS/$font-hinted
                cp $FONTS/$font-hinted $FONTS/$font
                rm $FONTS/$font-hinted

                echo "Subsetting $FONTS/$font"
                pyftsubset $FONTS/$font --unicodes-file="production/subset.txt" --name-IDs="*" --glyph-names --layout-features="*" --layout-features-="abvs,akhn,blwf,blws,cjct,half,pres,psts,rkrf,rphf,ss01,ss02,ss03,vatu,abvm,blwm,dist" --recalc-bounds --recalc-average-width --notdef-outline --output-file="$FONTS/$font-subset"
                cp $FONTS/$font-subset $FONTS/$font
                rm $FONTS/$font-subset

                # TODO update names
                
                gftools fix-dsig --autofix $FONTS/$font
            fi

            if [ $OTF ]; then
                echo "Compiling $FONTS/${ufo/ufo/otf}"
                font=${ufo/ufo/otf}
                font=${font/Rasa/Yrsa}
                rm $FONTS/$font
                fontmake -u $INSTANCES/$ufo --output otf --output-path $FONTS/$font --debug-feature-file debug.fea

                echo "Subsetting $FONTS/$font"
                pyftsubset $FONTS/$font --unicodes-file="production/subset.txt" --name-IDs="*" --glyph-names --layout-features="*" --layout-features-="abvs,akhn,blwf,blws,cjct,half,pres,psts,rkrf,rphf,ss01,ss02,ss03,vatu,abvm,blwm,dist" --recalc-bounds --recalc-average-width --notdef-outline --output-file="$FONTS/$font-subset"
                cp $FONTS/$font-subset $FONTS/$font
                rm $FONTS/$font-subset

                # TODO update names
                
                gftools fix-dsig --autofix $FONTS/$font
            fi
            
        fi
    done
fi


if [ $VF ]; then
    echo "Compile variable fonts"
    # TODO Variable fonts
fi

if [ $WOFF ]; then
    echo "Complile web font"
    # TODO Woffs
fi
