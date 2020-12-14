# Building the fonts from source

Requirements: 

Python 3 tools and libraries:
- fontmake (building UFOs and fonts)
- fonttools (manipulating features and fonts)
- gftools (manipualting fonts)
- defcon (manipulating UFOs)
- fontbakery (quality assurance)

Install via `pip install -r requirements.txt`

Command line tools:
- sfnt2woff-zopfli (woff generation with zopfli compression)([source](https://github.com/bramstein/sfnt2woff-zopfli))

This repo contains sources for Glyphs in folder `sources/`. The build command will extract and manipulate temporary UFO files in `sources/`. The fonts are built using a `fontmake` setup with additional files saved in `production/`. You can use the `build.sh` script in the `tools/` folder to replicate the process.

```
./build.sh -i -v -t -o -w -f Rasa/Yrsa
-i   interpolate new instances
-v   build Variable fonts
-t   build TTF fonts
-o   build OTF fonts
-w   compress woff2 and woff files from existing TTF fonts
-f   specify which subfamily (Rasa or Yrsa) to compile, or leave empty to compile both
```

## Examples

`./build.sh -i -t -f Rasa` builds static TTF instances for Rasa in `fonts/Rasa/`.

`./build.sh` builds all instance TTF & OTFs, Variable fonts, and WOFF & WOFF2 files for Rasa & Yrsa