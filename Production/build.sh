#!/usr/bin/env bash

if [ -z $1 ]
then
	echo "Use: build.sh -f <Family Name> -d -i -r -t -o"
	echo "-f   either Rasa or Yrsa"
	echo "-d   deletes old instances"
	echo "-i   interpolate new instances"
	echo "-r   generate TTF instances from UFO instances"
	echo "-t   build OTF fonts"
	echo "-o   build OTF fonts"
fi

while getopts f:dirto option
do
	case "${option}" in
		f) FAMILY=${OPTARG};;
		d) DELETE="D";;
		i) INTERPOLATE="I";;
		r) ROBO="R";;
		t) TTF="T";;
		o) OTF="O";;
	esac
done

if [ "$FAMILY" == "Rasa" -o "$FAMILY" == "Yrsa" ]
then
	# delete old UFO instances
	if [ $DELETE ]
	then
		cd "$FAMILY"
		shopt -s nullglob
		for i in */
		do
			UFO=$i"font.ufo"
			TTF=$i"font.ttf"
			OTF=$i"font.otf"
			if [[ -d $UFO ]]
			then
				echo "Removing old $UFO"
				rm -R $UFO
			fi
			if [[ -f $TTF ]]
			then
				echo "Removing old $TTF"
				rm $TTF
			fi
			if [[ -f $OTF ]]
			then
				echo "Removing old $OTF"
				rm $OTF
			fi
		done
		cd ..
	fi

	# generate new UFO instances & feature files
	if [ $INTERPOLATE ]
	then
		makeInstancesUFO -d $FAMILY.designspace -n

		cd "$FAMILY"
		for i in */
		do
			cd "$i"
			appendGroupsUFO.py -g ../../shared.groups.txt font.ufo
			cd ..
		done
		generateAllKernFiles.py
		generateAllMarkFiles.py
		cd ..
	fi

	# generate TTFs from UFOs (via RoboFont)
	if [ $ROBO ]
	then	
		cd "$FAMILY"
		for i in */
		do
			cd "$i"
			echo "Generating TTF in $FAMILY/$i"
			roboGenerateFont.py font.ufo -r -c -f ttf
			cd ..
		done
		cd ..
	fi

	# build TTF fonts
	if [ $TTF ]
	then	
		cd "$FAMILY"
		for i in */
		do
			cd "$i"
			STYLE=`echo "$i" | sed -e "s/\([^-\.]*\)\//\1/"`
			FONT=../../../Fonts/$FAMILY-$STYLE.ttf
			echo "Building TTF fonts from $FAMILY/$i"
			makeotf -f font.ttf -o ../../../Fonts/$FAMILY-$STYLE.ttf -ff features.fea -gf GlyphOrderAndAliasDB -r
			# subset Yrsa to Latin only
			if [ "$FAMILY" == "Yrsa" ]
			then
				pyftsubset $FONT --unicodes-file=../subset.txt --output-file=$FONT.S --layout-features='*' --glyph-names --notdef-glyph --notdef-outline --recommended-glyphs --name-IDs='*' --name-legacy --name-languages='*' --legacy-cmap --no-symbol-cmap --no-ignore-missing-unicodes
				rm $FONT
				mv $FONT.S $FONT
			fi
			# autohint
			ttfautohint $FONT $FONT.AH --hinting-range-max=96 --ignore-restrictions --strong-stem-width=G --increase-x-height=14
			rm $FONT
			mv $FONT.AH $FONT
			cd ..
		done
		cd ..
	fi

	# build OTF fonts
	if [ $OTF ]
	then	
		cd "$FAMILY"
		for i in */
		do
			cd "$i"
			STYLE=`echo "$i" | sed -e "s/\([^-\.]*\)\//\1/"`
			FONT=../../../Fonts/$FAMILY-$STYLE.otf
			echo "Building OTF fonts from $FAMILY/$i"
			makeotf -f font.ufo -o $FONT -ff features.fea -gf GlyphOrderAndAliasDB -r
			# subset Yrsa to Latin only
			if [ "$FAMILY" == "Yrsa" ]
			then
				pyftsubset $FONT --unicodes-file=../subset.txt --output-file=$FONT.S --layout-features='*' --glyph-names --notdef-glyph --notdef-outline --recommended-glyphs --name-IDs='*' --name-legacy --name-languages='*' --legacy-cmap --no-symbol-cmap --no-ignore-missing-unicodes
				rm $FONT
				mv $FONT.S $FONT
			fi
			cd ..
		done
		cd ..
	fi
else
	echo "Wrong name of a family. Use Rasa or Yrsa."
fi
