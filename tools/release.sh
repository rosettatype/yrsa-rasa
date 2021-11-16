
echo "Release archive helper script, for maintainers of the repo :)"

if [$1 == ""]
then
    echo "Pass in a new version tag to create, increment at least from below and match what is in the font files!"
    git tag
    exit
fi


echo "Tagging version $1"
git tag -f $1


RASA="release/Rasa-fonts-$1"
echo "Packaging $RASA.zip"
mkdir $RASA
cp documentation/FONTLOG.md $RASA/FONTLOG.txt
cp OFL.txt $RASA/OFL.txt
cp README.MD $RASA/README.txt
mkdir $RASA/otf
mkdir $RASA/ttf
mkdir $RASA/variable
cp fonts/Rasa/*.otf $RASA/otf/
cp fonts/Rasa/*.ttf $RASA/ttf/
cp fonts/RasaVariable/RasaVF-Ups.ttf $RASA/variable/
TMP=${RASA//release\//}
mv $RASA $TMP
zip -r $RASA.zip $TMP
rm -r $RASA
rm -r $TMP


YRSA="release/Yrsa-fonts-$1"
echo "Packaging $YRSA.zip"
mkdir $YRSA
cp documentation/FONTLOG.md $YRSA/FONTLOG.txt
cp OFL.txt $YRSA/OFL.txt
cp README.MD $YRSA/README.txt
mkdir $YRSA/otf
mkdir $YRSA/ttf
mkdir $YRSA/variable
cp fonts/Yrsa/*.otf $YRSA/otf/
cp fonts/Yrsa/*.ttf $YRSA/ttf/
cp fonts/YrsaVariable/* $YRSA/variable/
TMP=${YRSA//release\//}
mv $YRSA $TMP
zip -r $YRSA.zip $TMP
rm -r $YRSA
rm -r $TMP


echo "Push the tag (and commit) to github with '$ git push origin master --tags' and attach the generated zip files in /release to the new release :)"
