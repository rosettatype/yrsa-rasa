"""
A helper script to try extract some reasonable defaults for a stylespace
document from a designspace.

You will in all likelyhood need to manually edit this generated stylespace, but
this saves a lot of the typing.

NOTE: That this assumes a well defined and valid designspace!

@author: Johannes Neumeier <hello@underscoretype.com>
@repository: https://gist.github.com/kontur/2b11e93d0c639d550e9c45376e366cc8
"""
from fontTools import designspaceLib as dsLib
import argparse
import pathlib
import plistlib
import logging


def get_axis_value(dsAxis, val):
    mapped = [pair[0] for pair in dsAxis.map if pair[1] == val]
    if mapped:
        val = mapped[0]
    return val


def get_location(ds, axisName, value, roundToInt=False, ranges=False,
                 values=[], locationName=None):
    """
    Get a location dict with name, value (and range) from passed in
    designspace, axisname and value

    TODO Refactor as class method that has access to the CLI arguments
    """
    axis = [a for a in ds.axes if a.serialize()["name"] == axisName][0]
    value = get_axis_value(axis, value)

    if not locationName:
        logging.warning("Review location name for '%s' - '%s'" %
                        (axisName, str(value)))

    loc = {
        "name": locationName or "NAMEME",
        "value": value if not roundToInt else round(value),
    }

    # Define ranges; for values on the axis extremes go from extrem to
    # half the next highest/lowest, for values on the axis use half to
    # next lower to half to next higher (let's not worry about overalp
    # on same value (half way), the spec takes care of that)
    if ranges and len(values) > 1 and value in values:
        i = values.index(value)
        loc["range"] = []
        if i == 0:
            loc["range"].append(value)
        else:
            loc["range"].append((values[i-1] + values[i]) / 2)

        if i == len(values) - 1:
            loc["range"].append(value)
        else:
            loc["range"].append((values[i] + values[i+1]) / 2)
        if roundToInt:
            loc["range"] = [round(r) for r in loc["range"]]

    return loc


def main():
    # TODO: Could refactor args to use click, since we are already using it
    parser = argparse.ArgumentParser()
    parser.add_argument('ds', type=pathlib.Path)
    parser.add_argument(
        '--round', help="Round values to integers", action="store_true")
    parser.add_argument(
        '--ranges', help="Define locations with ranges", action="store_true")
    args = parser.parse_args()

    logging.getLogger().setLevel(logging.INFO)

    output = str(args.ds).replace(".designspace", ".stylespace")
    ds = dsLib.DesignSpaceDocument()
    ds.read(args.ds)

    axes = {}
    for a in ds.axes:
        a = a.serialize()
        axes[a["name"]] = {
            "name": a["name"],
            "tag": a["tag"]
        }

    locations = {}

    # For a single axis designspace we can use the defined instance's names to
    # set a location name
    if len(axes) == 1:
        axisName = list(axes.keys())[0]
        axis = [a for a in ds.axes if a.serialize()["name"] == axisName][0]
        vals = [get_axis_value(axis, i.location[axisName])
                for i in ds.instances]
        locs = []
        for i in ds.instances:
            for k, v in i.location.items():
                loc = get_location(ds, k, v, args.round, args.ranges, vals,
                                   i.styleName)
                locs.append(loc)
        axes[axisName]["locations"] = locs

    # For designspaces with several axes the instance style names yield no
    # reliable location name, so mark all locations with names to be manually
    # overwritten
    else:
        for i in ds.instances:
            for k, v in i.location.items():
                if k not in locations:
                    locations[k] = []
                locations[k].append(v)

        for k, v in locations.items():
            vals = sorted(list(set(v)))
            locs = []

            # Make vals a list of unique, user space values
            for val in vals:
                loc = get_location(ds, k, val, args.round, args.ranges, vals)
                locs.append(loc)

            axes[k]["locations"] = locs

    with open(output, "wb") as doc:
        plistlib.dump({"axes": list(axes.values())}, doc)

    logging.info("Stylespace template '%s' created" % output)


if __name__ == "__main__":
    main()
