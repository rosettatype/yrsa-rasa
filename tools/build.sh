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
# -c: Check the TTF files
# -w: Compile webfonts
#
MASTERS="sources/masters"
INSTANCES="sources/instances"
FONTS="fonts"

TTF=0
OTF=0
STATIC=0
VF=0
WOFF=0
UFO=0
RASA=0
YRSA=0
CHECKS=0

while getopts "civtowf:" opt
do
	case "${opt}" in
        c) CHECKS=1;;
        i) STATIC=1;;
        v) VF=1;;
		t) TTF=1;;
		o) OTF=1;;
        w) WOFF=1;;
        # u) UFO=1;;  # for now determine this based on TTF/OTF option
        f) FAMILY=$OPTARG;;
	esac
done

# Fall back to use ttf if no format was specified
if [ "$TTF" == 0 ] && [ "$OTF" == 0 ] && [ "$WOFF" == 0 ]; then
    TTF=1
    OTF=1
fi

# Extract UFOs if compiling new binaries
if [ "$TTF" == 1 ] || [ "$OTF" == 1 ]; then
    UFO=1
fi

# Fall back to compile both, statics and variable fonts
if [ "$STATIC" == 0 ] && [ "$VF" == 0 ] && [ "$CHECKS" == 0 ]; then
    STATIC=1
    VF=1
fi

# Output family: Rasa, Yrsa, or both
case $FAMILY in
    Yrsa) YRSA=1;;
    Rasa) RASA=1;;
    *) YRSA=1 RASA=1;;
esac


echo "Running with input:"
echo ""
echo "INSTANCES: $STATIC"
echo "VARIABLE FONT: $VF"
echo "CHECKS: $CHECKS"
echo ""
echo "UFO: $UFO"
echo "OTF: $OTF"
echo "TTF: $TTF"
echo "WOFF: $WOFF"
echo ""
echo "RASA: $RASA"
echo "YRSA: $YRSA"
echo ""


if [ "$UFO" == 1 ]; then
    rm -rf $MASTERS
    rm -rf $INSTANCES

    # Extract UFOs from the glyphs sources
    echo "Extracting UFOs from Glyph sources"
    fontmake -g sources/Rasa-MM.glyphs -o ufo --interpolate --master-dir=$MASTERS --instance-dir=$INSTANCES
    fontmake -g "sources/RasaItalics-MM.glyphs" -o ufo --interpolate --master-dir=$MASTERS --instance-dir=$INSTANCES

    # Tmp fix for https://github.com/googlefonts/fontmake/issues/722
    cp -r sources/masters/sources/instances/* sources/instances
    rm -r sources/master/sources

fi


if [ "$STATIC" == 1 ] && ([ "$TTF" == 1 ] || [ "$OTF" == 1 ]); then
    echo ""
    echo "Compiling instances"
    
    mkdir -p "fonts"

    # Loop through the instances and prepare and compile each of them
    for ufo in $(ls $INSTANCES); do

        # Make sure mark features get written without any "design" anchors left over
        echo "Preparing $INSTANCES/$ufo"
        python tools/remove-anchors-from-ufo.py $INSTANCES/$ufo periodcentred _periodcentred apostrophe _apostrophe


        if [ "$RASA" == 1 ]; then
            # Combine and write our custom features to the UFOs
            echo "Write features to $INSTANCES/$ufo"
            if [[ "$ufo" == *Italic.ufo* ]]; then
                python tools/parse-features.py production/features/italics.fea $INSTANCES/$ufo
            else
                python tools/parse-features.py production/features/uprights-rasa.fea $INSTANCES/$ufo
            fi


            mkdir -p "fonts/Rasa"


            if [ "$TTF" == 1 ]; then
                FILE=$FONTS/Rasa/${ufo/ufo/ttf}
                rm -f $FILE

                echo "Compiling $FILE"
                fontmake -u $INSTANCES/$ufo --output ttf --output-path $FILE --flatten-components --no-production-names --autohint

                echo "Autohinting $FILE"
                ttfautohint $FILE $FILE-hinted
                cp $FILE-hinted $FILE
                rm $FILE-hinted
                
                gftools fix-hinting $FILE
                rm $FILE
                mv $FILE.fix $FILE
                
                gftools fix-dsig --autofix $FILE
            fi


            if [ "$OTF" == 1 ]; then
                FILE=$FONTS/Rasa/${ufo/ufo/otf}
                rm -f $FILE

                echo "Compiling $FILE"
                fontmake -u $INSTANCES/$ufo --output otf --output-path $FILE --flatten-components --no-production-names

                echo "Autohinting $FILE"
                psautohint $FILE
                
                gftools fix-dsig --autofix $FILE
            fi
        fi


        if [ "$YRSA" == 1 ]; then
            # Combine and write our custom features to the UFOs
            echo "Write features to $INSTANCES/$ufo"
            if [[ "$ufo" == *Italic.ufo* ]]; then
                python tools/parse-features.py production/features/italics.fea $INSTANCES/$ufo
            else
                python tools/parse-features.py production/features/uprights-yrsa.fea $INSTANCES/$ufo
            fi


            mkdir -p "fonts/Yrsa"


            if [ "$TTF" == 1 ]; then
                FILE=$FONTS/Yrsa/${ufo/ufo/ttf}
                FILE=${FILE/Rasa/Yrsa}
                rm -f $FILE

                echo "Compiling $FILE"
                fontmake -u $INSTANCES/$ufo --output ttf --output-path $FILE --flatten-components --no-production-names --autohint

                echo "Autohinting $FILE"
                ttfautohint $FILE $FILE-hinted
                cp $FILE-hinted $FILE
                rm $FILE-hinted

                echo "Subsetting $FILE"
                pyftsubset $FILE --unicodes-file="production/subset.txt" --name-IDs="*" --glyph-names --layout-features="*" --layout-features-="abvs,akhn,blwf,blws,cjct,half,pres,psts,rkrf,rphf,ss01,ss02,ss03,vatu,abvm,blwm,dist" --recalc-bounds --recalc-average-width --notdef-outline --output-file="$FILE-subset"
                cp $FILE-subset $FILE
                rm $FILE-subset

                python tools/replace-family-name.py $FILE Rasa Yrsa
                
                gftools fix-hinting $FILE
                rm $FILE
                mv $FILE.fix $FILE
                
                gftools fix-dsig --autofix $FILE
            fi


            if [ "$OTF" == 1 ]; then
                FILE=$FONTS/Yrsa/${ufo/ufo/otf}
                FILE=${FILE/Rasa/Yrsa}
                rm -f $FILE

                echo "Compiling $FILE"
                fontmake -u $INSTANCES/$ufo --output otf --output-path $FILE --flatten-components --no-production-names

                echo "Subsetting $FILE"
                pyftsubset $FILE --unicodes-file="production/subset.txt" --name-IDs="*" --glyph-names --layout-features="*" --layout-features-="abvs,akhn,blwf,blws,cjct,half,pres,psts,rkrf,rphf,ss01,ss02,ss03,vatu,abvm,blwm,dist" --recalc-bounds --recalc-average-width --notdef-outline --output-file="$FILE-subset"
                cp $FILE-subset $FILE
                rm $FILE-subset

                echo "Autohinting $FILE"
                psautohint $FILE

                python tools/replace-family-name.py $FILE Rasa Yrsa
                
                gftools fix-dsig --autofix $FILE
            fi
            
        fi
    done
fi


if [ "$VF" == 1 ] && ([ "$TTF" == 1 ] || [ "$OTF" == 1 ]); then
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
        python tools/remove-anchors-from-ufo.py $INSTANCES/$ufo periodcentred _periodcentred apostrophe _apostrophe
    done


    if [ "$RASA" == 1 ]; then

        mkdir -p $FONTS/RasaVariable

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
        STYLES=(Ups Its)
        for STYLE in ${STYLES[*]}; do
            FILE=$FONTS/RasaVariable/RasaVF-$STYLE.ttf
            DS=production/Rasa-$STYLE.designspace
            SS=production/Rasa.stylespace

            fontmake -m $DS -o variable --output-path=$FILE --flatten-components --no-production-names

            # Add STAT table
            echo "Add STAT table"
            statmake --designspace $DS --stylespace $SS $FILE

            gftools fix-nonhinting $FILE $FILE.fix
            mv $FILE.fix $FILE
            rm -f "${FILE/.ttf/-backup-fonttools-prep-gasp.ttf}"

            gftools fix-unwanted-tables $FILE

            gftools fix-dsig --autofix $FILE
        done
    fi


    if [ "$YRSA" == 1 ]; then

        mkdir -p $FONTS/YrsaVariable

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
        # having removed the anchor the stem component decomposes and the anchor 
        # will still be in the glyph — maybe some anchor ordering issue with the
        # different instance sources/UFOs?!
        # ¯\_(ツ)_/¯
        STYLES=(Ups Its)
        for STYLE in ${STYLES[*]}; do
            FILE=$FONTS/YrsaVariable/YrsaVF-$STYLE.ttf
            # Note that Design- and Stylespace documents are those of Rasa, we
            # only subset the font after compiling
            DS=production/Rasa-$STYLE.designspace
            SS=production/Rasa.stylespace

            fontmake -m production/Rasa-$STYLE.designspace -o variable --output-path=$FILE --flatten-components --no-production-names

            # Add STAT table
            statmake --designspace $DS --stylespace $SS $FILE

            echo "Subsetting $FILE"
            pyftsubset $FILE --unicodes-file="production/subset.txt" --name-IDs="*" --glyph-names --layout-features="*" --layout-features-="abvs,akhn,blwf,blws,cjct,half,pres,psts,rkrf,rphf,ss01,ss02,ss03,vatu,abvm,blwm,dist" --recalc-bounds --recalc-average-width --notdef-outline --output-file="$FILE-subset"
            cp $FILE-subset $FILE
            rm $FILE-subset

            python tools/replace-family-name.py $FILE Rasa Yrsa

            gftools fix-nonhinting $FILE $FILE.fix
            mv $FILE.fix $FILE
            rm -f "${FILE/.ttf/-backup-fonttools-prep-gasp.ttf}"
            
            gftools fix-unwanted-tables $FILE

            gftools fix-dsig --autofix $FILE
        done
    fi
fi

if [ "$WOFF" == 1 ]; then
    echo "Compile web fonts"

    if [ "$RASA" == 1 ] && [ "$YRSA" == 1 ]; then
        FAMILY="."
    elif [ "$RASA" == 1 ]; then
        FAMILY="Rasa"
    elif [ "$YRSA" == 1 ]; then
        FAMILY="Yrsa"
    fi

    for FOLDER in $(ls $FONTS | grep $FAMILY | grep -v Web); do
        rm -rf $FONTS/${FOLDER}Web
        mkdir -p $FONTS/${FOLDER}Web
        for FILE in $(ls $FONTS/$FOLDER | grep .ttf); do
            echo "Compiling web font from $FILE"
            IN=$FONTS/$FOLDER/$FILE
            OUT=$FONTS/${FOLDER}Web/${FILE/-/Web-}
            OUT=${OUT/ttf/woff}

            # Woff2 (using fonttools, since the project already requires it)
            python tools/save-woff2.py $IN ${OUT}2
            
            # Output woff only for static files, not for Variable Fonts
            if [[ $IN != *"VF"* ]]; then
                # Woff (using sfnt2woff binary with zopfli compression)
                sfnt2woff-zopfli $IN
                mv ${IN/ttf/woff} $OUT
            fi
        done
    done
fi


if [ "$CHECKS" == 1 ]; then
    echo "Check fonts"

    if [ "$RASA" == 1 ] && [ "$YRSA" == 1 ]; then
        FAMILY="."
    elif [ "$RASA" == 1 ]; then
        FAMILY="Rasa"
    elif [ "$YRSA" == 1 ]; then
        FAMILY="Yrsa"
    fi

    for FOLDER in $(ls $FONTS | grep $FAMILY | grep -v Web); do
        for FILE in $(ls $FONTS/$FOLDER | grep ttf); do
            FONT=$FONTS/$FOLDER/$FILE
            mkdir -p tests/$FOLDER
            fontbakery check-googlefonts $FONT -l WARN -m WARN --ghmarkdown tests/$FOLDER/$FILE-test.md
        done
    done
fi
