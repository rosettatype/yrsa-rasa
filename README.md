# Yrsa & Rasa

**Yrsa** and **Rasa** are open-source type families published by [Rosetta](https://rosettatype.com) with generous financial support from Google. The fonts are going to support some 45+2 languages in Latin and Gujarati scripts in 5 weights and will be freely available from the Google Fonts directory, once it is ready. Design and production are done in-house, by [Anna Giedryś](http://ancymonic.com) ([@ancymonic](http://github.com/ancymonic)) and [David Březina](http://davi.cz) ([@MrBrezina](http://github.com/MrBrezina)).

Yrsa is the name of the Latin-only type family. Rasa is the name of the Gujarati type family. In terms of glyphs included Rasa is a superset of Yrsa, it includes the complete Latin.

What makes Yrsa & Rasa project different is the design approach. It is a deliberate experiment in remixing existing typefaces to produce a new one. The Latin part is based on [Merriweather](http://sorkintype.com/fonts.html#mw) by Eben Sorkin. The Gujarati is based on David Březina’s [Skolar Gujarati](https://www.rosettatype.com/Skolar#gujarati).

See the [Yrsa & Rasa project page](http://github.rosettatype.com/yrsa) for details.


## Download

You can download the fonts from `Fonts/` folder of this repo.


## Language support

In **Gujarati** script: Gujarati and Kachchi.

In **Latin** script (Adobe Latin 3 character set): major Western European Latin languages (a.k.a. Roman languages) as well as Afrikaans, Basque, Breton, Catalan, Croatian (Latin), Czech, Estonian, Danish, Dutch, English, Faroese, Finnish, French, Gaelic, Gagauz (Latin), German, Hungarian, Icelandic, Indonesian, Irish, Italian, Javanese (Latin), Kashubian, Latvian, Lithuanian, Malay (Latin), Moldovan (Latin), Norwegian, Polish, Portuguese, Romanian (Latin), Sami (Southern, Northern, Inari, and Lule), Serbian (Latin), Silesian, Sorbian, Slovak, Slovenian, Spanish, Swahili, Swedish, Turkish, and Walloon.


## Rosetta – world typography specialists

Rosetta addresses the needs of global typography. Together with our collaborators we create original fonts for a polyphonic world. Our work has been featured and awarded. But most importantly it has enabled people to read better in their native language.

So far our retail library supports pan-European Latin, Arabic, Armenian, Greek, Cyrillic (besides Slavic languages we also support many Asian languages), Inuktitut, and Indic scripts like Gujarati and Devanagari. In total, the library covers more than 200 languages.

For more information see the website at http://rosettatype.com.

You can contact us at <ask@rosettatype.com>.


## License

See `LICENSE.txt` for licensing information. Essentially, the fonts and related code are licensed under [Open Font License](http://scripts.sil.org/OFL).


## Feedback & progress

This version is now considered final. Let us know if you spot any problem (via issues).


## Building the fonts from source

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

For example `./build.sh -f Rasa -i` interpolates and uploads individual UFOs for all instances and `./build.sh -f Rasa -o` then builds OTF fonts from these instances and saves them in the `Fons/` folder.


## Changelog

This is version 1.000 and seems to be stable. :)




