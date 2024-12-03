import os
import sys
from PIL import Image
from .teamcolor import *
from .util import save_image, transform_files_recursively, noop
from typing import Iterable

PalettableType = Color | list[Color] | tuple[Color]

def palettable_to_palette(palettable: Palette):
    match palettable:
        case Color():
            return get_palette(palettable)
        case [*items] | (*items,):
            result = []
            for color in palettable:
                result += get_palette(color)
            return result
    return []


def _recolor_image(
        image : Image,
        input_palette  : Palette,
        output_palette : Palette):
    pixels = image.load()
    assert len(input_palette.rgb_shades) == len(output_palette.rgb_shades)
    for x in range(image.width):
        for y in range(image.height):
            r, g, b, a = pixels[x, y]
            if (r, g, b) not in input_palette.rgb_shades:
                continue
            k = input_palette.rgb_shades.index((r, g, b))
            r, g, b = output_palette.rgb_shades[k]
            pixels[x, y] = r, g, b, a


def recolor_image(
        image : Image,
        input_colors  : Palettable,
        output_colors : Palettable):
    input_palette  = get_palette(input_colors)
    output_palette = get_palette(output_colors)
    _recolor_image(image, input_palette, output_palette)


def recolor_file(
        input_path : str,
        output_path : str,
        input_colors  : Palettable,
        output_colors : Palettable):
    with Image.open(input_path) as image:
        rgba_image = image.convert("RGBA")
        recolor_image(rgba_image, input_colors, output_colors)
        save_image(rgba_image, output_path)


def color_to_colorname(color : Palettable):
    match color:
        case Color():
            human_color_name = str(color)
        case CoColors():
            human_color_name = "+".join(str(subcolor) for subcolor in color.subcolors)
        case _:
            raise TypeError("color argument must be either a Color or a CoColors")
    return human_color_name.lower().removeprefix("base ").replace(" ", "")


def color_from_colorname(colorname : str):
    try:
        return next(color for color in Color if color_to_colorname(color) == colorname)
    except StopIteration:
        raise ValueError(f"{repr(colorname)} is not a valid color name.")


def recolor_folder(
        input_path  : str,
        output_path : str,
        input_color   : Palettable                        = Color.BaseMagenta,
        output_colors : Palettable | Iterable[Palettable] = Color.wesnoth_colors,
        separate_colors_by_subfolders=False,
        add_color_suffixes=False,
        update_only=False,
        ):
    
    assert isPalettable(input_color)
    if isPalettable(output_colors):
        output_colors = [output_colors]
    else:
        output_colors = list(output_colors)
    
    if len(output_colors) == 1 and not separate_colors_by_subfolders and not add_color_suffixes:
        raise ValueError("You must enable either separate_colors_by_subfolders or add_color_suffix if you want to recolor to many colors")

    for output_color in output_colors:
        color_name = color_to_colorname(output_color)

        output_path_for_color = output_path
        if separate_colors_by_subfolders:
            output_path_for_color = os.path.join(output_path, color_name)
        
        def transform_file_cb(input_path, output_path):
            recolor_file(input_path, output_path, input_color, output_color)

        color_suffix = ""
        if add_color_suffixes:
            color_suffix = f"-{color_name}"

        transform_files_recursively(
            input_path,
            output_path_for_color,
            transform_file_cb,
            output_suffix=color_suffix,
            update_only=update_only,
            )


def run_recolor(args):
    co_input_color = None
    co_output_colors = None
    if getattr(args, "from"):
        co_input_color = CoColors([color_from_colorname(color_string) for color_string in getattr(args, "from").split(",")])
    if args.to:
        co_output_colors = [CoColors([color_from_colorname(color_string) for color_string in color_tuple_string.split(",")]) for color_tuple_string in args.to]
    recolor_folder(
        args.input,
        args.output,
        input_color = co_input_color,
        output_colors = co_output_colors,
        separate_colors_by_subfolders = args.color_folders,
        add_color_suffixes = args.color_suffixes,
        update_only=args.update_only,
    )

