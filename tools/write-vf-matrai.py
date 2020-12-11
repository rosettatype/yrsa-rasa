"""
For the Matra I substitutions we have a list of compiled, style-specific,
substitutions that pick the "correct length" Matra I for any number of 
syllables. For the Variable font we want to compare the substitutions for all
styles and for all syllables pick the one substitution that does not overshoot
at any weight value, e.g. pick the "shortest"
"""
import os
import re

features = "production/features/"
weights = ["Light", "Regular", "Medium", "SemiBold", "Bold"]
matrai = "matrai.abvs.fea"

files = [os.path.join(features, w, matrai) for w in weights]
subs = []
reSub = re.compile("(^sub.*)(?=gjMatraI\.)gjMatraI\.(\d+)")
shortest_subs = []

for f in files:
    with open(f, "r") as fea:
        weight_subs = []
        for line in fea.read().split("\n"):
            if line.strip() == "":
                continue
            matches = reSub.findall(line)
            if not matches:
                # A line with gjMatraI without suffix
                weight_subs.append((0, line))
            else:
                # The matched suffix, the matched line
                weight_subs.append((matches[0][1], matches[0][0] + "gjMatraI"))
        subs.append(weight_subs)

for i in range(len(subs[0])):
    shortest_suffix = False
    shortest_sub = False
    for s in subs:
        if shortest_suffix is False or int(s[i][0]) < shortest_suffix:
            shortest_suffix = int(s[i][0])
            shortest_sub = s[i][1]

    if shortest_suffix == 0:
        shortest_subs.append(shortest_sub)  # full matched line has semicolon
    else:
        shortest_subs.append(shortest_sub + "." + str(shortest_suffix) + ";")

with open(os.path.join(features, "VF", matrai), "w") as f:
    f.write("\n".join(shortest_subs))
