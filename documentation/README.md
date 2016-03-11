# Yrsa & Rasa: building the fonts from source

Requirements: [AFDKO](https://github.com/adobe-type-tools/afdko), [defcon](https://github.com/typesupply/defcon), [FontTools](https://github.com/behdad/fonttools), and [appendGroupsUFO.py](https://github.com/rosettatype/Post-production-scripts) script. In order to compile TTF fonts, RoboFont and custom shell script [roboGenerateFont.py](https://github.com/rosettatype/Post-production-scripts) are used.

This repo contains sources for Glyphs, TrueType-flavoured OpenType `.ttf` and PostScript-flavoured OpenType `.otf` font files. The UFO files are a derived source, exported from Glyphs. 

The fonts are built using AFDKO from the UFOs use the `build.sh` script in the Production folder:

```
./build.sh -f <Family Name> -d -i -r -t -o
-f   either Rasa or Yrsa
-d   deletes old instances
-i   interpolate new instances
-r   generate TTF instances from UFO instances
-t   build OTF fonts
-o   build OTF fonts
```

## Examples

`./build.sh -f Rasa -i` interpolates UFOs from  `sources/builds` and uploads individual instances to corresponding folders in `production/`.

`./build.sh -f Rasa -o` builds OTF fonts from the instances in `production/` and saves them in the `fonts/` folder