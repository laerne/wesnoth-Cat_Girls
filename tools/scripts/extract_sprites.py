#!/usr/bin/env python

# Save in dict: Layer visibility, layer opacity

# Hide all toplevels layers

# For each recognized toplevel layer (UNITS, PROJECTILES, HALOS, ...):
#   Recursively at each layer group:
#     Unhide all layers that start with +
#     recurse for each layer with a +
#     Hide all layer that do no start with +
#     For each of the layers withouth +, unhide it and recurse
#     If at bottom of arborescence, export with combined name.
#          (i.e. Concatenating layers names, removing the possible + prefix and anything in between [ and ] )
#     Hide the layer that was just recursed

