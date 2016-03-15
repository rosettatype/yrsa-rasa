# Building the fonts from source

Requirements: [AFDKO](https://github.com/adobe-type-tools/afdko), [defcon](https://github.com/typesupply/defcon), [FontTools](https://github.com/behdad/fonttools), and [appendGroupsUFO.py](https://github.com/rosettatype/Post-production-scripts) script. In order to compile TTF fonts, RoboFont and custom shell script [roboGenerateFont.py](https://github.com/rosettatype/Post-production-scripts) are used.

This repo contains sources for Glyphs in folder `sources/`. The UFO files in `sources/builds/` are a derived source, exported from Glyphs. The fonts are built using AFDKO setup saved in `production/`. You can use the `build.sh` script in the `tools/` folder to replicate the process.

```
./build.sh -d -i -r -t -o -x -z
-d   deletes old instances
-i   interpolate new instances
-r   generate TTF instances from UFO instances
-t   build OTF fonts
-o   build TTF fonts
-x   make TTX files from the OTFs and TTFs
-z   create zip for release, needs a family name as parameter, 
     this filters the fonts that are included in the release
```

## Examples

`./build.sh -i` interpolates UFOs from  `sources/builds` and uploads individual instances to corresponding folders in `production/`.

`./build.sh -o` builds OTF fonts from the instances in `production/` and saves them in the `compiled/` folder which is not tracked in this repo.