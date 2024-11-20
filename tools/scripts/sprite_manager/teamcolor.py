from . import util
import os.path
from enum import StrEnum
from PIL import Image
from dataclasses import dataclass, field
from typing import Any
import itertools

class Color(StrEnum):
    BaseMagenta  = "Base Magenta"
    Red          = "Red"
    Blue         = "Blue"
    Green        = "Green"
    Purple       = "Purple"
    Black        = "Black"
    Brown        = "Brown"
    Orange       = "Orange"
    White        = "White"
    Teal         = "Teal"
    LightRed     = "Light Red"
    DarkRed      = "Dark Red"
    LightBlue    = "Light Blue"
    BrightGreen  = "Bright Green"
    BrightOrange = "Bright Orange"
    Gold         = "Gold"
    BaseCyan     = "Base Cyan"
    Indigo       = "Indigo"
    SkyBlue      = "Sky Blue"
    IndianYellow = "Indian Yellow"

Color.all = list(Color)
Color.base_colors     = [color for color in Color if     str(color).startswith("Base ")]
Color.non_base_colors = [color for color in Color if not str(color).startswith("Base ")]

Color.default_wesnoth_colors = [
    Color.Red,
    Color.Blue,
    Color.Green,
    Color.Purple,
    Color.Black,
    Color.Brown,
    Color.Orange,
    Color.White,
    Color.Teal,
]

Color.wesnoth_colors = Color.default_wesnoth_colors + [
    Color.LightRed,
    Color.DarkRed,
    Color.LightBlue,
    Color.BrightGreen,
    Color.BrightOrange,
    Color.Gold,
]

Color.feu_ra_colors = [
    Color.Indigo,
    Color.SkyBlue,
    Color.IndianYellow,
]

@dataclass
class CoColors:
    subcolors : list[Color] = field(default_factory=list)

Palettable = Color | CoColors

def isPalettable(palettable : Any):
    return isinstance(palettable, Color) or isinstance(palettable, CoColors)

@dataclass
class Palette:
    rgb_shades : list[(int, int, int)] = field(default_factory=list)

def join_palettes(*palettes : list[Palette]):
    return Palette(list(itertools.chain.from_iterable(palette.rgb_shades for palette_generator in palettes for palette in palette_generator)))

_color_to_palette_map : dict[Color, Palette] = {}
def load_palettes(path = None):
    if path is None:
        path = os.path.join(os.path.dirname(__file__), "teamcolors.png")
    with Image.open(path) as image:
        pixels = image.convert(mode = "RGB").load()
        for j, color in enumerate(Color):
            _color_to_palette_map[color] = Palette()
            for i in range(image.width):
                _color_to_palette_map[color].rgb_shades.append(pixels[i, j])
load_palettes()

def get_palette(color : Color | CoColors):
    match color:
        case Color():
            return _color_to_palette_map[color]
        case CoColors():
            return join_palettes(_color_to_palette_map[subcolor] for subcolor in color.subcolors)
        case _:
            raise TypeError("color argument must be either a Color or a CoColors")
