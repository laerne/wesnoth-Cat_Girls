import os
import re
import sys
from PIL import Image
from .teamcolor import *
from .util import save_image, list_files_recursively, path_to_splitpath, get_time
from typing import Iterable

PalettableType = Color | list[Color] | tuple[Color]

color_sep_re = re.compile(" *[,/+\\;:] *")

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
        output_colors : Palettable,
        keep_old_files_on_equality : bool = False):
    with Image.open(input_path) as image:
        rgba_image = image.convert("RGBA")
        recolor_image(rgba_image, input_colors, output_colors)
        if output_path != input_path:
            print(f"Transforming: {input_path}\nto: {output_path}", end='')
        else:
            print(f"Updating: {output_path}", end='')
        did_save_image = save_image(rgba_image, output_path)
        if did_save_image:
            print()
        else:
            print(" [No pixels to update]")
            

def _color_to_colorname(color : Color):
    return str(color).lower().removeprefix("base ").replace(" ", "")


def color_to_colorname(color : Palettable):
    match color:
        case Color():
            return _color_to_colorname(color)
        case CoColors():
            return "+".join(_color_to_colorname(subcolor) for subcolor in color.subcolors)
        case _:
            raise TypeError("color argument must be either a Color or a CoColors")


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
        separate_color_by_mid_subfolders = False,
        add_color_suffixes = False,
        recursive = False,
        update_only = False,
        keep_old_files_on_equality = False,
        ):
    
    assert isPalettable(input_color)
    if isPalettable(output_colors):
        output_colors = [output_colors]
    else:
        output_colors = list(output_colors)
    
    if len(output_colors) > 1 and not separate_color_by_mid_subfolders and not add_color_suffixes:
        raise ValueError("You must enable either separate_color_by_mid_subfolders or add_color_suffix if you want to recolor to many colors")

    split_input_back_paths = list_files_recursively(input_path, recursive)
    split_output_path = path_to_splitpath(output_path, nonexistant_is_dir = os.path.isdir(input_path))

    for output_color in output_colors:
        color_name = color_to_colorname(output_color)

        for split_input_back_path in split_input_back_paths:
            split_output_back_path = split_output_path.replaced_with(mid = split_input_back_path.mid, back = split_input_back_path.back)
            if separate_color_by_mid_subfolders:
                split_output_back_path = split_output_back_path.with_prepended_mid_folder(color_name)
            if add_color_suffixes:
                split_output_back_path = split_output_back_path.with_back_suffix("-" + color_name)

            if update_only and get_time(split_input_back_path) <= get_time(split_output_back_path):
                print(f"Up-to-date: {str(split_output_back_path)}")
                continue
            recolor_file(split_input_back_path.abs(), split_output_back_path.abs(), input_color, output_color, keep_old_files_on_equality)


def run_recolor(args):
    co_input_color = None
    co_output_colors = None
    if getattr(args, "from"):
        co_input_color = CoColors([color_from_colorname(color_string) for color_string in color_sep_re.split(getattr(args, "from"))])
    if args.to:
        co_output_colors = [CoColors([color_from_colorname(color_string) for color_string in color_sep_re.split(color_tuple_string)]) for color_tuple_string in args.to]

    recolor_folder(
        args.input,
        args.output,
        input_color = co_input_color,
        output_colors = co_output_colors,
        separate_color_by_mid_subfolders = args.color_folders,
        add_color_suffixes = args.color_suffixes,
        recursive = args.recursive,
        update_only=args.update_only or args.strong_update_only,
        keep_old_files_on_equality=args.strong_update_only,
    )

