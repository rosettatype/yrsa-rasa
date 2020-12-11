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
UFO=1 # For now just force UFO extraction from glyphs source for every call

while getopts "ivtowuf:" opt
do
	case "${opt}" in
        i) STATIC=1;;
        v) VF=1;;
		t) TTF=1;;
		o) OTF=1;;
        w) WOFF=1;;
        # u) UFO=1;;
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


echo "Compiling with input:"
echo "INSTANCES: $STATIC"
echo "VARIABLE FONT: $VF"
echo "OTF: $OTF"
echo "TTF: $TTF"
echo "WOFF: $WOFF"
echo "RASA: $RASA"
echo "YRSA: $YRSA"


if [ $UFO == 1 ]; then
    rm -rf $MASTERS
    rm -rf $INSTANCES

    # Extract UFOs from the glyphs sources
    echo "Extracting UFOs from Glyph sources"
    fontmake -g sources/Rasa-MM.glyphs -o ufo --interpolate --master-dir=$MASTERS --instance-dir=$INSTANCES
    fontmake -g "sources/Rasa Italics-MM.glyphs" -o ufo --interpolate --master-dir=$MASTERS --instance-dir=$INSTANCES
fi


if [ $STATIC == 1 ]; then
    echo ""
    echo "Compiling instances"
    
    mkdir "fonts"

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


            mkdir "fonts/Rasa"


            if [ $TTF == 1 ]; then
                FILE=$FONTS/Rasa/${ufo/ufo/ttf}
                rm -f $FILE

                echo "Compiling $FILE"
                fontmake -u $INSTANCES/$ufo --output ttf --output-path $FILE

                echo "Autohinting $FILE"
                ttfautohint $FILE $FILE-hinted
                cp $FILE-hinted $FILE
                rm $FILE-hinted
                
                gftools fix-dsig --autofix $FILE
            fi


            if [ $OTF == 1 ]; then
                FILE=$FONTS/Rasa/${ufo/ufo/otf}
                rm -f $FILE

                echo "Compiling $FILE"
                fontmake -u $INSTANCES/$ufo --output otf --output-path $FILE
                
                gftools fix-dsig --autofix $FILE
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


            mkdir "fonts/Yrsa"


            if [ $TTF == 1 ]; then
                FILE=$FONTS/Yrsa/${ufo/ufo/ttf}
                FILE=${FILE/Rasa/Yrsa}
                rm -f $FILE

                echo "Compiling $FILE"
                fontmake -u $INSTANCES/$ufo --output ttf --output-path $FILE

                echo "Autohinting $FILE"
                ttfautohint $FILE $FILE-hinted
                cp $FILE-hinted $FILE
                rm $FILE-hinted

                echo "Subsetting $FILE"
                pyftsubset $FILE --unicodes-file="production/subset.txt" --name-IDs="*" --glyph-names --layout-features="*" --layout-features-="abvs,akhn,blwf,blws,cjct,half,pres,psts,rkrf,rphf,ss01,ss02,ss03,vatu,abvm,blwm,dist" --recalc-bounds --recalc-average-width --notdef-outline --output-file="$FILE-subset"
                cp $FILE-subset $FILE
                rm $FILE-subset

                python tools/replace-family-name.py $FILE Rasa Yrsa
                
                gftools fix-dsig --autofix $FILE
            fi


            if [ $OTF == 1 ]; then
                FILE=$FONTS/Yrsa/${ufo/ufo/otf}
                FILE=${FILE/Rasa/Yrsa}
                rm -f $FILE

                echo "Compiling $FILE"
                fontmake -u $INSTANCES/$ufo --output otf --output-path $FILE

                echo "Subsetting $FILE"
                pyftsubset $FILE --unicodes-file="production/subset.txt" --name-IDs="*" --glyph-names --layout-features="*" --layout-features-="abvs,akhn,blwf,blws,cjct,half,pres,psts,rkrf,rphf,ss01,ss02,ss03,vatu,abvm,blwm,dist" --recalc-bounds --recalc-average-width --notdef-outline --output-file="$FILE-subset"
                cp $FILE-subset $FILE
                rm $FILE-subset

                python tools/replace-family-name.py $FILE Rasa Yrsa
                
                gftools fix-dsig --autofix $FILE
            fi
            
        fi
    done
fi


if [ $VF == 1 ]; then
    echo "Compile variable fonts"

    # fontmake extracted master_ufo and instance_ufo are slightly different so
    # since we want to use "instance" Rasa-Regular.ufo as "master" we need to
    # make all masters use the "instance" UFO to be compatible
    rm -rf $MASTERS/*

    cp -r $INSTANCES/Rasa-Light.ufo $MASTERS/Rasa-Light.ufo
    cp -r $INSTANCES/Rasa-Regular.ufo $MASTERS/Rasa-Regular.ufo
    cp -r $INSTANCES/Rasa-Bold.ufo $MASTERS/Rasa-Bold.ufo

    cp -r $INSTANCES/Rasa-LightItalic.ufo $MASTERS/Rasa-LightItalic.ufo
    cp -r $INSTANCES/Rasa-Italic.ufo $MASTERS/Rasa-Italic.ufo
    cp -r $INSTANCES/Rasa-BoldItalic.ufo $MASTERS/Rasa-BoldItalic.ufo

    # Loop through the instances and prepare each of them
    for ufo in $(ls $MASTERS | grep .ufo); do
        # Make sure mark features get written without any "design" anchors left over
        echo "Preparing $MASTERS/$ufo"
        python tools/remove-anchors-from-ufo.py $MASTERS/$ufo periodcentred _periodcentred
    done


    if [ $RASA == 1 ]; then

        mkdir $FONTS/RasaVF

        echo "Compiling VF matra I lookup"
        python tools/write-vf-matrai.py

        # Loop through the instances and prepare and compile each of them
        for ufo in $(ls $MASTERS | grep .ufo); do
            # Combine and write our custom features to the UFOs
            echo "Write features to $MASTERS/$ufo"
            if [[ "$ufo" == *Italic.ufo* ]]; then
                python tools/parse-features.py production/features/italics.fea $MASTERS/$ufo
            else
                python tools/parse-features.py production/features/uprights-rasa.fea $MASTERS/$ufo VF
            fi
        done

        # A bug in the region of etheral: If the glyph gjDYa in Rasa-MM.glyphs has
        # the abvmTOP anchor, fonttools will inexplicably fail to compile; however,
        # having removed the stem component decomposes and the anchor will still
        # be in the glyph — maybe some anchor ordering issue with the different
        # instance sources/UFOs?!
        # ¯\_(ツ)_/¯
        STYLES=(Uprights Italics)
        for STYLE in ${STYLES[*]}; do
            FILE=$FONTS/RasaVF/RasaVF-$STYLE.ttf
            fontmake -m production/Rasa-$STYLE.designspace -o variable --output-path=$FILE
            gftools fix-dsig --autofix $FILE
        done
    fi


    if [ $YRSA == 1 ]; then

        mkdir $FONTS/YrsaVF

        # Loop through the instances and prepare and compile each of them
        for ufo in $(ls $MASTERS | grep .ufo); do
            # Combine and write our custom features to the UFOs
            echo "Write features to $MASTERS/$ufo"
            if [[ "$ufo" == *Italic.ufo* ]]; then
                python tools/parse-features.py production/features/italics.fea $MASTERS/$ufo
            else
                python tools/parse-features.py production/features/uprights-yrsa.fea $MASTERS/$ufo
            fi
        done

        # A bug in the region of etheral: If the glyph gjDYa in Rasa-MM.glyphs has
        # the abvmTOP anchor, fonttools will inexplicably fail to compile; however,
        # having removed the stem component decomposes and the anchor will still
        # be in the glyph — maybe some anchor ordering issue with the different
        # instance sources/UFOs?!
        # ¯\_(ツ)_/¯
        STYLES=(Uprights Italics)
        for STYLE in ${STYLES[*]}; do
            FILE=$FONTS/YrsaVF/YrsaVF-$STYLE.ttf
            fontmake -m production/Rasa-$STYLE.designspace -o variable --output-path=$FILE

            echo "Subsetting $FILE"
            pyftsubset $FILE --unicodes-file="production/subset.txt" --name-IDs="*" --glyph-names --layout-features="*" --layout-features-="abvs,akhn,blwf,blws,cjct,half,pres,psts,rkrf,rphf,ss01,ss02,ss03,vatu,abvm,blwm,dist" --recalc-bounds --recalc-average-width --notdef-outline --output-file="$FILE-subset"
            cp $FILE-subset $FILE
            rm $FILE-subset

            python tools/replace-family-name.py $FILE Rasa Yrsa

            gftools fix-dsig --autofix $FILE
        done
    fi
fi

if [ $WOFF == 1 ]; then
    echo "Complile web font"
    # TODO Woffs
fi
