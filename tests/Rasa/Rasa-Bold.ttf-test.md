## Fontbakery report

Fontbakery version: 0.7.33

<details>
<summary><b>[15] Rasa-Bold.ttf</b></summary>
<details>
<summary>💔 <b>ERROR:</b> Show hinting filesize impact.</summary>

* [com.google.fonts/check/hinting_impact](https://font-bakery.readthedocs.io/en/latest/fontbakery/profiles/googlefonts.html#com.google.fonts/check/hinting_impact)
<pre>--- Rationale ---

This check is merely informative, displaying and useful comparison of filesizes
of hinted versus unhinted font files.


</pre>

* 💔 **ERROR** The condition <FontBakeryCondition:hinting_stats> had an error: OSError: Could not find the libc shared library

</details>
<details>
<summary>💔 <b>ERROR:</b> Font has old ttfautohint applied?</summary>

* [com.google.fonts/check/old_ttfautohint](https://font-bakery.readthedocs.io/en/latest/fontbakery/profiles/googlefonts.html#com.google.fonts/check/old_ttfautohint)
<pre>--- Rationale ---

This check finds which version of ttfautohint was used, by inspecting name
table entries and then finds which version of ttfautohint is currently
installed in the system.


</pre>

* 💔 **ERROR** The check <FontBakeryCheck:com.google.fonts/check/old_ttfautohint> had an error: FailedConditionError: The condition <FontBakeryCondition:hinting_stats> had an error: OSError: Could not find the libc shared library

</details>
<details>
<summary>🔥 <b>FAIL:</b> Check license file has good copyright string.</summary>

* [com.google.fonts/check/license/OFL_copyright](https://font-bakery.readthedocs.io/en/latest/fontbakery/profiles/googlefonts.html#com.google.fonts/check/license/OFL_copyright)
<pre>--- Rationale ---

An OFL.txt file&#x27;s first line should be the font copyright e.g:
&quot;Copyright 2019 The Montserrat Project Authors
(https://github.com/julietaula/montserrat)&quot;


</pre>

* 🔥 **FAIL** First line in license file does not match expected format: "copyright 2010 yrsa and rasa project authors (info@rosettatype.com)"

</details>
<details>
<summary>🔥 <b>FAIL:</b> Check copyright namerecords match license file.</summary>

* [com.google.fonts/check/name/license](https://font-bakery.readthedocs.io/en/latest/fontbakery/profiles/googlefonts.html#com.google.fonts/check/name/license)
<pre>--- Rationale ---

A known licensing description must be provided in the NameID 14 (LICENSE
DESCRIPTION) entries of the name table.

The source of truth for this check (to determine which license is in use) is a
file placed side-by-side to your font project including the licensing terms.

Depending on the chosen license, one of the following string snippets is
expected to be found on the NameID 13 (LICENSE DESCRIPTION) entries of the name
table:
- &quot;This Font Software is licensed under the SIL Open Font License, Version 1.1.
This license is available with a FAQ at: https://scripts.sil.org/OFL&quot;
- &quot;Licensed under the Apache License, Version 2.0&quot;
- &quot;Licensed under the Ubuntu Font Licence 1.0.&quot;


Currently accepted licenses are Apache or Open Font License.
For a small set of legacy families the Ubuntu Font License may be acceptable as
well.

When in doubt, please choose OFL for new font projects.


</pre>

* 🔥 **FAIL** License file LICENSE.txt exists but NameID 13 (LICENSE DESCRIPTION) value on platform 3 (WINDOWS) is not specified for that. Value was: "This Font Software is licensed under the SIL Open Font License, Version 1.1. This license is available with a FAQ at: https://scripts.sil.org/OFL" Must be changed to "Licensed under the Apache License, Version 2.0" [code: wrong]

</details>
<details>
<summary>🔥 <b>FAIL:</b> Copyright notices match canonical pattern in fonts</summary>

* [com.google.fonts/check/font_copyright](https://font-bakery.readthedocs.io/en/latest/fontbakery/profiles/googlefonts.html#com.google.fonts/check/font_copyright)

* 🔥 **FAIL** Name Table entry: Copyright notices should match a pattern similar to: "Copyright 2019 The Familyname Project Authors (git url)"
But instead we have got:
"Copyright 2010 Yrsa and Rasa Project Authors (info@rosettatype.com)" [code: bad-notice-format]

</details>
<details>
<summary>🔥 <b>FAIL:</b> Check if the vertical metrics of a family are similar to the same family hosted on Google Fonts.</summary>

* [com.google.fonts/check/vertical_metrics_regressions](https://font-bakery.readthedocs.io/en/latest/fontbakery/profiles/googlefonts.html#com.google.fonts/check/vertical_metrics_regressions)
<pre>--- Rationale ---

If the family already exists on Google Fonts, we need to ensure that the
checked family&#x27;s vertical metrics are similar. This check will test the
following schema which was outlined in Fontbakery issue #1162 [1]:

- The family should visually have the same vertical metrics as the Regular
style hosted on Google Fonts.
- If the family on Google Fonts has differing hhea and typo metrics, the family
being checked should use the typo metrics for both the hhea and typo entries.
- If the family on Google Fonts has use typo metrics not enabled and the family
being checked has it enabled, the hhea and typo metrics should use the family
on Google Fonts winAscent and winDescent values.
- If the upms differ, the values must be scaled so the visual appearance is the
same.

[1] https://github.com/googlefonts/fontbakery/issues/1162


</pre>

* 🔥 **FAIL** Rasa Bold: OS/2 sTypoAscender is 971 when it should be 728 [code: bad-typo-ascender]
* 🔥 **FAIL** Rasa Bold: OS/2 sTypoDescender is -423 when it should be -272 [code: bad-typo-descender]
* 🔥 **FAIL** Rasa Bold: hhea Ascender is 971 when it should be 728 [code: bad-hhea-ascender]
* 🔥 **FAIL** Rasa Bold: hhea Descender is -423 when it should be -272 [code: bad-hhea-descender]

</details>
<details>
<summary>⚠ <b>WARN:</b> Glyphs are similiar to Google Fonts version?</summary>

* [com.google.fonts/check/production_glyphs_similarity](https://font-bakery.readthedocs.io/en/latest/fontbakery/profiles/googlefonts.html#com.google.fonts/check/production_glyphs_similarity)

* ⚠ **WARN** Following glyphs differ greatly from Google Fonts version: [at, currency, dollar, dollar.tf, eng, guillemotright.gujr, guilsinglright.gujr, m, minute, n, nacute, napostrophe, ncaron, ntilde, oe, percent, perthousand, second, trademark, uni1E9E, uni20B9, uni20B9.tf, uni20BA, uni20BA.tf, w, wacute, wcircumflex, wdieresis, wgrave, yen]

</details>
<details>
<summary>⚠ <b>WARN:</b> Check if each glyph has the recommended amount of contours.</summary>

* [com.google.fonts/check/contour_count](https://font-bakery.readthedocs.io/en/latest/fontbakery/profiles/googlefonts.html#com.google.fonts/check/contour_count)
<pre>--- Rationale ---

Visually QAing thousands of glyphs by hand is tiring. Most glyphs can only be
constructured in a handful of ways. This means a glyph&#x27;s contour count will
only differ slightly amongst different fonts, e.g a &#x27;g&#x27; could either be 2 or 3
contours, depending on whether its double story or single story.

However, a quotedbl should have 2 contours, unless the font belongs to a
display family.

This check currently does not cover variable fonts because there&#x27;s plenty of
alternative ways of constructing glyphs with multiple outlines for each feature
in a VarFont. The expected contour count data for this check is currently
optimized for the typical construction of glyphs in static fonts.


</pre>

* ⚠ **WARN** This check inspects the glyph outlines and detects the total number of contours in each of them. The expected values are infered from the typical ammounts of contours observed in a large collection of reference font families. The divergences listed below may simply indicate a significantly different design on some of your glyphs. On the other hand, some of these may flag actual bugs in the font such as glyphs mapped to an incorrect codepoint. Please consider reviewing the design and codepoint assignment of these to make sure they are correct.

The following glyphs do not have the recommended number of contours:

Glyph name: uni1E08	Contours detected: 3	Expected: 2
Glyph name: uni1E09	Contours detected: 3	Expected: 2
Glyph name: uni1E1C	Contours detected: 3	Expected: 2
Glyph name: uni1E1D	Contours detected: 4	Expected: 3
Glyph name: uni200C	Contours detected: 1	Expected: 0
Glyph name: uni200D	Contours detected: 1	Expected: 0
Glyph name: uni1E08	Contours detected: 3	Expected: 2
Glyph name: uni1E09	Contours detected: 3	Expected: 2
Glyph name: uni1E1C	Contours detected: 3	Expected: 2
Glyph name: uni1E1D	Contours detected: 4	Expected: 3
Glyph name: uni200C	Contours detected: 1	Expected: 0
Glyph name: uni200D	Contours detected: 1	Expected: 0 [code: contour-count]

</details>
<details>
<summary>⚠ <b>WARN:</b> Are there caret positions declared for every ligature?</summary>

* [com.google.fonts/check/ligature_carets](https://font-bakery.readthedocs.io/en/latest/fontbakery/profiles/googlefonts.html#com.google.fonts/check/ligature_carets)
<pre>--- Rationale ---

All ligatures in a font must have corresponding caret (text cursor) positions
defined in the GDEF table, otherwhise, users may experience issues with caret
rendering.

If using GlyphsApp, ligature carets can be set directly on canvas by accessing
the `Glyph -&gt; Set Anchors` menu option or by pressing the `Cmd+U` keyboard
shortcut.

If designing with UFOs, (as of Oct 2020) ligature carets are not yet compiled
by ufo2ft, and therefore will not build via FontMake. See
googlefonts/ufo2ft/issues/329


</pre>

* ⚠ **WARN** This font lacks caret position values for ligature glyphs on its GDEF table. [code: lacks-caret-pos]

</details>
<details>
<summary>⚠ <b>WARN:</b> Is there kerning info for non-ligated sequences?</summary>

* [com.google.fonts/check/kerning_for_non_ligated_sequences](https://font-bakery.readthedocs.io/en/latest/fontbakery/profiles/googlefonts.html#com.google.fonts/check/kerning_for_non_ligated_sequences)
<pre>--- Rationale ---

Fonts with ligatures should have kerning on the corresponding non-ligated
sequences for text where ligatures aren&#x27;t used (eg
https://github.com/impallari/Raleway/issues/14).


</pre>

* ⚠ **WARN** GPOS table lacks kerning info for the following non-ligated sequences:
	- f + i
	- i + j
	- j + t
	- germandbls + i
	- f.ascender + i
	- f.f + i

   [code: lacks-kern-info]

</details>
<details>
<summary>⚠ <b>WARN:</b> Glyph names are all valid?</summary>

* [com.google.fonts/check/valid_glyphnames](https://font-bakery.readthedocs.io/en/latest/fontbakery/profiles/universal.html#com.google.fonts/check/valid_glyphnames)
<pre>--- Rationale ---

Microsoft&#x27;s recommendations for OpenType Fonts states the following:

&#x27;NOTE: The PostScript glyph name must be no longer than 31 characters, include
only uppercase or lowercase English letters, European digits, the period or the
underscore, i.e. from the set [A-Za-z0-9_.] and should start with a letter,
except the special glyph name &quot;.notdef&quot; which starts with a period.&#x27;

https://docs.microsoft.com/en-us/typography/opentype/spec/recom#post-table


In practice, though, particularly in modern environments, glyph names can be as
long as 63 characters.
According to the &quot;Adobe Glyph List Specification&quot; available at:

https://github.com/adobe-type-tools/agl-specification


</pre>

* ⚠ **WARN** The following glyph names may be too long for some legacy systems which may expect a maximum 31-char length limit:
gjMatraCandraO_gjReph_gjAnusvara and gjMatraCandraE_gjReph_gjAnusvara [code: legacy-long-names]

</details>
<details>
<summary>⚠ <b>WARN:</b> Check mark characters are in GDEF mark glyph class</summary>

* [com.google.fonts/check/gdef_mark_chars](https://font-bakery.readthedocs.io/en/latest/fontbakery/profiles/gdef.html#com.google.fonts/check/gdef_mark_chars)
<pre>--- Rationale ---

Mark characters should be in the GDEF mark glyph class.


</pre>

* ⚠ **WARN** The following mark characters could be in the GDEF mark glyph class:
	 U+0335, U+0A83, U+0ABE, U+0ABF, U+0AC0, U+0AC9, U+0ACB and U+0ACC [code: mark-chars]

</details>
<details>
<summary>⚠ <b>WARN:</b> Do any segments have colinear vectors?</summary>

* [com.google.fonts/check/outline_colinear_vectors](https://font-bakery.readthedocs.io/en/latest/fontbakery/profiles/<Section: Outline Correctness Checks>.html#com.google.fonts/check/outline_colinear_vectors)
<pre>--- Rationale ---

This test looks for consecutive line segments which have the same angle. This
normally happens if an outline point has been added by accident.

This test is not run for variable fonts, as they may legitimately have colinear
vectors.


</pre>

* ⚠ **WARN** The following glyphs have colinear vectors:
	* arrowboth: L<<198.0,323.0>--<258.0,329.0>> -> L<<258.0,329.0>--<717.0,329.0>>
	* arrowboth: L<<258.0,329.0>--<717.0,329.0>> -> L<<717.0,329.0>--<777.0,323.0>>
	* arrowboth: L<<717.0,243.0>--<258.0,243.0>> -> L<<258.0,243.0>--<198.0,249.0>>
	* arrowdown: L<<322.0,205.0>--<328.0,265.0>> -> L<<328.0,265.0>--<328.0,538.0>>
	* arrowleft: L<<197.0,322.0>--<258.0,328.0>> -> L<<258.0,328.0>--<531.0,328.0>>
	* arrowup: L<<322.0,380.0>--<328.0,320.0>> -> L<<328.0,320.0>--<328.0,47.0>>
	* arrowupdown: L<<322.0,573.0>--<328.0,512.0>> -> L<<328.0,512.0>--<328.0,54.0>>
	* arrowupdown: L<<328.0,512.0>--<328.0,54.0>> -> L<<328.0,54.0>--<322.0,-7.0>>
	* dagger: L<<119.0,413.0>--<113.0,503.0>> -> L<<113.0,503.0>--<113.0,573.0>>
	* dagger: L<<251.0,573.0>--<251.0,503.0>> -> L<<251.0,503.0>--<245.0,413.0>> and 25 more. [code: found-colinear-vectors]

</details>
<details>
<summary>⚠ <b>WARN:</b> Do outlines contain any jaggy segments?</summary>

* [com.google.fonts/check/outline_jaggy_segments](https://font-bakery.readthedocs.io/en/latest/fontbakery/profiles/<Section: Outline Correctness Checks>.html#com.google.fonts/check/outline_jaggy_segments)
<pre>--- Rationale ---

This test heuristically detects outline segments which form a particularly
small angle, indicative of an outline error. This may cause false positives in
cases such as extreme ink traps, so should be regarded as advisory and backed
up by manual inspection.


</pre>

* ⚠ **WARN** The following glyphs have jaggy segments:
	* aogonek: L<<327.0,-5.0>--<327.0,-5.0>>/B<<327.0,-5.0>-<306.0,-1.0>-<291.0,10.0>> = 10.784297867562596
	* at.case: B<<459.5,200.0>-<461.0,220.0>-<464.0,241.0>>/B<<464.0,241.0>-<440.0,157.0>-<406.0,117.0>> = 7.815293546766825
	* at: B<<459.5,110.0>-<461.0,130.0>-<464.0,151.0>>/B<<464.0,151.0>-<440.0,67.0>-<406.0,27.0>> = 7.815293546766825
	* gjDGha.ss01: L<<204.0,171.0>--<204.0,171.0>>/B<<204.0,171.0>-<165.0,172.0>-<142.5,152.5>> = 1.4688007143857
	* three.dnom: B<<290.0,219.0>-<260.0,197.0>-<225.0,192.0>>/B<<225.0,192.0>-<253.0,192.0>-<278.0,183.5>> = 8.13010235415596
	* three.lf.tf: B<<373.5,355.0>-<336.0,318.0>-<277.0,306.0>>/B<<277.0,306.0>-<315.0,308.0>-<352.5,294.0>> = 8.483775513402376
	* three.lf: B<<364.5,355.0>-<327.0,318.0>-<268.0,306.0>>/B<<268.0,306.0>-<306.0,308.0>-<343.5,294.0>> = 8.483775513402376
	* three.numr: B<<290.0,446.0>-<260.0,424.0>-<225.0,419.0>>/B<<225.0,419.0>-<253.0,419.0>-<278.0,410.5>> = 8.13010235415596
	* three.tf: B<<356.5,315.5>-<322.0,282.0>-<272.0,269.0>>/B<<272.0,269.0>-<307.0,271.0>-<341.0,259.5>> = 11.303728274855175
	* three: B<<337.5,315.5>-<303.0,282.0>-<253.0,269.0>>/B<<253.0,269.0>-<288.0,271.0>-<322.0,259.5>> = 11.303728274855175 and 6 more. [code: found-jaggy-segments]

</details>
<details>
<summary>⚠ <b>WARN:</b> Do outlines contain any semi-vertical or semi-horizontal lines?</summary>

* [com.google.fonts/check/outline_semi_vertical](https://font-bakery.readthedocs.io/en/latest/fontbakery/profiles/<Section: Outline Correctness Checks>.html#com.google.fonts/check/outline_semi_vertical)
<pre>--- Rationale ---

This test detects line segments which are nearly, but not quite, exactly
horizontal or vertical. Sometimes such lines are created by design, but often
they are indicative of a design error.

This test is disabled for italic styles, which often contain nearly-upright
lines.


</pre>

* ⚠ **WARN** The following glyphs have semi-vertical/semi-horizontal lines:
	* bar: L<<168.0,693.0>--<167.0,-116.0>>
	* estimated: L<<472.0,237.0>--<176.0,238.0>>
	* gjJh: L<<389.0,368.0>--<388.0,507.0>>
	* gjJhRa: L<<400.0,368.0>--<399.0,507.0>>
	* gjJha: L<<389.0,368.0>--<388.0,507.0>>
	* gjVocalicL: L<<356.0,372.0>--<355.0,507.0>>
	* gjVocalicLl: L<<356.0,372.0>--<355.0,507.0>>
	* pi: L<<186.0,423.0>--<511.0,425.0>> and uni018F: L<<43.0,287.0>--<385.0,286.0>> [code: found-semi-vertical]

</details>
<br>
</details>

### Summary

| 💔 ERROR | 🔥 FAIL | ⚠ WARN | 💤 SKIP | ℹ INFO | 🍞 PASS | 🔎 DEBUG |
|:-----:|:----:|:----:|:----:|:----:|:----:|:----:|
| 2 | 4 | 9 | 86 | 7 | 86 | 0 |
| 1% | 2% | 5% | 44% | 4% | 44% | 0% |

**Note:** The following loglevels were omitted in this report:
* **SKIP**
* **INFO**
* **PASS**
* **DEBUG**
