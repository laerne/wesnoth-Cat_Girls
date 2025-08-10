#!/usr/bin/env python

import io
import itertools
import json
import os
import sys

from dataclasses import dataclass
from typing import Optional

from PIL import Image

from .util import list_files_recursively, SplitPath, path_to_splitpath, get_time, get_git_root, PathRoot


def to2d(json_item):
    match json_item:
        case None: return [None, None]
        case [x, y]: return [x, y]
        case (x, y): return [x, y]
        case {'x' : x, 'y' : y}: return [x, y]
        case _: raise ValueError("Invalid 2D value")


@dataclass(slots=True, frozen=True)
class FrameInfo:
    gif_input_path     : SplitPath
    wml_input_path     : SplitPath
    gif_duration       : int
    wml_duration       : int
    is_time_origin     : bool
    frame_prefix       : str
    offset             : tuple[int, int]
    directional_offset : tuple[int, int]
    opacity            : float
    other_wml_info     : dict[str, str]

    def replaced_with(self, **kwargs):
        assert frozenset(kwargs) <= frozenset(self.__slots__)
        data = { key : getattr(self, key) for key in self.__slots__ }
        data.update(kwargs)
        return FrameInfo(**data)

    def add_other_wml_info(self, **kwargs):
        data = { key : getattr(self, key) for key in self.__slots__ }
        data.setdefault("other_wml_info", {}).update(kwargs)
        return FrameInfo(**data)

    def frame_label(self):
        if self.frame_prefix:
            return f"{self.frame_prefix}_frame"
        else:
            return "frame"


@dataclass(slots=True, frozen=True)
class AnimationInfo:
    name            : str
    start_time      : int
    frames          : list[FrameInfo]
    gif_output_path : Optional[SplitPath]
    wml_output_path : Optional[SplitPath]

    def replaced_with(self, **kwargs):
        assert frozenset(kwargs) <= frozenset(self.__slots__)
        data = { key : getattr(self, key) for key in self.__slots__ }
        data.update(kwargs)
        return FrameInfo(**data)


@dataclass(slots=True, frozen=True)
class AnimationFileInfo:
    gif_root_path                : SplitPath
    wml_root_path                : SplitPath
    gif_animations_to_export     : list[str]
    wml_animations_to_export     : list[str]
    gif_path_variable_variations : list[dict[str, str]]
    wml_path_variable_variations : list[dict[str, str]]
    fallback_frame               : Optional[FrameInfo]


def load_json_includes(json_object, animation_file_path):
    match json_object:
        case { "#include" : include_path, **key_values }:
            abs_include_path = path_to_splitpath(
                    include_path,
                    nonexistant_is_dir = False).abs(
                    cwd = animation_file_path.abs("mid"))
            with open(abs_include_path, "rt") as stream:
                raw_included_json = json.load(stream)
                included_json = load_json_includes(raw_included_json, path_to_splitpath(abs_include_path, nonexistant_is_dir=False))
                if isinstance(included_json, dict):
                    overwritten_json = load_json_includes({ **key_values }, animation_file_path)
                    return { **included_json, **overwritten_json }
                else:
                    return included_json
        
        case { **key_values }:
            return {key : load_json_includes(value, animation_file_path) for key, value in key_values.items()}
        
        case [ *values ]:
            return [load_json_includes(value, animation_file_path) for value in values]
        
        case _:
            return json_object

    raise ValueError(f"Invalid json object of type {type(json_object)}")


def get_path(json_object, key, root_path : SplitPath, nonexistant_is_dir : bool = False):
    if key not in json_object:
        return None

    path = path_to_splitpath(json_object[key], nonexistant_is_dir)
    assert path.mid == ""
    if path.root == PathRoot.LocalFolderRoot:
        path = root_path.with_appended_mid_folder(path.front).replaced_with(back = path.back)
    return path


def make_automatic_path_variables(
        name,
        number_of_frames,
        animation_file_path,
        gif_output_path,
        wml_output_path):
    automatic_path_variables = {
        "$name"                 : name,
        "$frame_count"          : number_of_frames,
        "$gif_output_dir"       : gif_output_path.str("mid"),
        "$wml_output_dir"       : wml_output_path.str("mid"),
        "$animation_input_dir"  : animation_file_path.str("mid"),
        "$gif_output_file"      : gif_output_path.back,
        "$wml_output_file"      : wml_output_path.back,
        "$animation_input_file" : animation_file_path.back}
    return automatic_path_variables


class PathVariableDict(dict):
    def __init__(self, *pargs, **kwargs):
        super().__init__(*pargs, **kwargs)

    def __getitem__(self, key):
        varname = key.strip(" !%'()+,-./=@[]_`{}~")
        i = key.index(varname)
        j = i + len(varname)
        prefix = key[:i]
        suffix = key[j:]
        value = super().__getitem__(varname)
        if value:
            return prefix + value + suffix
        else:
            return value


def apply_path_variables(split_path : SplitPath, path_variables : dict[str, str]):
    path_variable_dict = PathVariableDict(path_variables)
    root  = split_path.root
    front = split_path.front.format_map(path_variable_dict)
    mid   = split_path.mid  .format_map(path_variable_dict)
    back  = split_path.back .format_map(path_variable_dict)
    return SplitPath(root, front, mid, back)


def parse_frame(
        json_object,
        fallback_frame : Optional[FrameInfo],
        gif_root_path  : SplitPath,
        wml_root_path  : SplitPath):

    if "$gif_input_path" in json_object:
        gif_input_path = get_path(json_object, "$gif_input_path", gif_root_path, nonexistant_is_dir=False)
    else:
        gif_input_path = get_path(json_object, "$input_path", gif_root_path, nonexistant_is_dir=False)

    if "$wml_input_path" in json_object:
        wml_input_path = get_path(json_object, "$wml_input_path", wml_root_path, nonexistant_is_dir=False)
    else:
        wml_input_path = get_path(json_object, "$input_path", wml_root_path, nonexistant_is_dir=False)

    duration = json_object.get("$duration")

    gif_duration = json_object.get("$gif_duration")
    if gif_duration is None: gif_duration = duration
    if gif_duration is None and fallback_frame is not None: gif_duration = fallback_frame.gif_duration
    assert gif_duration is not None

    wml_duration = json_object.get("$wml_duration")
    if wml_duration is None: wml_duration = duration
    if wml_duration is None and fallback_frame is not None: wml_duration = fallback_frame.wml_duration
    assert wml_duration is not None

    is_time_origin = json_object.get("$is_time_origin", False)

    frame_prefix = json_object.get("$frame_prefix")
    if frame_prefix is None and fallback_frame is not None: frame_prefix = fallback_frame.frame_prefix
    if frame_prefix is None: frame_prefix = ""

    offset = to2d(json_object.get("$offset"))
    if offset[0] is None and fallback_frame is not None: offset[0] =  fallback_frame.offset[0]
    if offset[0] is None: offset[0] = 0
    if offset[1] is None and fallback_frame is not None: offset[1] =  fallback_frame.offset[1]
    if offset[1] is None: offset[1] = 0

    directional_offset = to2d(json_object.get("$directional_offset"))
    if directional_offset[0] is None and fallback_frame is not None: directional_offset[0] = fallback_frame.directional_offset[0]
    if directional_offset[0] is None: directional_offset[0] = 0
    if directional_offset[1] is None and fallback_frame is not None: directional_offset[1] = fallback_frame.directional_offset[1]
    if directional_offset[1] is None: directional_offset[1] = 0

    opacity = json_object.get("$opacity")
    if opacity is None and fallback_frame is not None: opacity = fallback_frame.opacity
    if opacity is None: opacity = 1.0

    other_wml_info = json_object.get("$other_wml_info")
    if other_wml_info is None and fallback_frame is not None: other_wml_info = fallback_frame.other_wml_info
    if other_wml_info is None: other_wml_info = {}
    other_wml_info.update(json_object.get("$added_wml_info", {}))
    return FrameInfo(
        gif_input_path     = gif_input_path,
        wml_input_path     = wml_input_path,
        gif_duration       = gif_duration,
        wml_duration       = wml_duration,
        is_time_origin     = is_time_origin,
        frame_prefix       = frame_prefix,
        offset             = offset,
        directional_offset = directional_offset,
        opacity            = opacity,
        other_wml_info     = other_wml_info)


def parse_animation(
        name_key,
        main_json_object,
        animation_cache,
        root_fallback_frame : Optional[FrameInfo],
        gif_root_path  : SplitPath,
        wml_root_path  : SplitPath):
    json_object = main_json_object[name_key]

    name = json_object.get("$name", name_key)

    default_gif_output_path = get_path(json_object, "$output_path",     gif_root_path, nonexistant_is_dir = False) or gif_root_path
    gif_output_path         = get_path(json_object, "$gif_output_path", gif_root_path, nonexistant_is_dir = False) or output_path
    gif_output_path         = gif_output_path.with_back_extension(".gif")

    default_wml_output_path = get_path(json_object, "$output_path",     wml_root_path, nonexistant_is_dir = False) or wml_root_path
    wml_output_path         = get_path(json_object, "$wml_output_path", wml_root_path, nonexistant_is_dir = False) or output_path
    wml_output_path         = wml_output_path.with_back_extension(".wml")

    if "$default_frame" in json_object:
        fallback_frame = parse_frame(
                json_object["$default_frame"],
                root_fallback_frame,
                gif_root_path,
                wml_root_path)
    else:
        fallback_frame = root_fallback_frame

    frames = []
    for frame_data in json_object["$frames"]:
        if "$sub_animation" in frame_data:
            sub_animation_name = frame_data["$sub_animation"]
            if sub_animation_name in animation_cache:
                sub_animation = animation_cache[sub_animation_name]
            else:
                sub_animation = parse_animation(
                        sub_animation_name,
                        main_json_object,
                        animation_cache,
                        root_fallback_frame,
                        gif_root_path,
                        wml_root_path)
                animation_cache[sub_animation_name] = sub_animation

            if sub_animation.get("$is_time_origin", False):
                frames.extend(sub_animation["$frames"])
            else:
                frames.extend(frame.replaced_with(is_time_origin = False) for frame in sub_animation["$frames"])
        else:
            frames.append(parse_frame(
                frame_data,
                fallback_frame,
                gif_root_path,
                wml_root_path))

    start_time = json_object.get("$start_time")
    if start_time is None:
        accumulated_duration = 0
        for frame_info in frames:
            if frame_info.is_time_origin:
                break
            elif not frame_info.frame_prefix: # ignore non-default frames for duration computation
                accumulated_duration += frame_info.wml_duration
        else:
            accumulated_duration = 0
        start_time = -accumulated_duration

    return AnimationInfo(
        name            = name,
        start_time      = start_time,
        frames          = frames,
        gif_output_path = gif_output_path,
        wml_output_path = wml_output_path)


def parse_animation_file(json_object, animation_file_path : SplitPath):
    root_path     = get_path(json_object, "$root_path",     animation_file_path, nonexistant_is_dir=True) or animation_file_path
    gif_root_path = get_path(json_object, "$gif_root_path", animation_file_path, nonexistant_is_dir=True) or root_path
    wml_root_path = get_path(json_object, "$wml_root_path", animation_file_path, nonexistant_is_dir=True) or root_path

    def merge_unique(*lists):
        # Merge lists, remove duplicate, keep order.
        # It's O((n1+...+nk)^2), but since it's to be used with data filled by human, that should'nt be an issue.
        result = []
        for elem in itertools.chain(*lists):
            if elem not in result:
                result.append(elem)
        return result

    animations_to_export = json_object.get("$animations_to_export")
    gif_animations_to_export = merge_unique(json_object.get("$gif_animations_to_export", []), animations_to_export)
    wml_animations_to_export = merge_unique(json_object.get("$wml_animations_to_export", []), animations_to_export)

    path_variables = json_object.get("$path_variables", {})
    gif_path_variables = json_object.get("$gif_path_variables", {})
    wml_path_variables = json_object.get("$wml_path_variables", {})

    path_variable_variations     = json_object.get("$path_variable_variations", [])
    gif_path_variable_variations = json_object.get("$gif_path_variable_variations", path_variable_variations)
    wml_path_variable_variations = json_object.get("$wml_path_variable_variations", path_variable_variations)

    full_gif_path_variable_variations = [{ **path_variables, **gif_path_variables, **gif_path_variable_variation }
                                         for gif_path_variable_variation in gif_path_variable_variations]
    full_wml_path_variable_variations = [{ **path_variables, **wml_path_variables, **wml_path_variable_variation }
                                         for wml_path_variable_variation in wml_path_variable_variations]
    if not full_gif_path_variable_variations:
        full_gif_path_variable_variations = [{**path_variables, **gif_path_variables}]
    if not full_wml_path_variable_variations:
        full_wml_path_variable_variations = [{**path_variables, **wml_path_variables}]

    if "$default_frame" in json_object:
        fallback_frame = parse_frame(
                json_object["$default_frame"],
                None,
                gif_root_path,
                wml_root_path)
    else:
        fallback_frame = None

    return AnimationFileInfo(
        gif_root_path                = gif_root_path,
        wml_root_path                = wml_root_path,
        gif_animations_to_export     = gif_animations_to_export,
        wml_animations_to_export     = wml_animations_to_export,
        gif_path_variable_variations = full_gif_path_variable_variations,
        wml_path_variable_variations = full_wml_path_variable_variations,
        fallback_frame               = fallback_frame)


def parse_main(json_object, animation_file_path : SplitPath):
    animation_cache = {}
    animation_infos = {}
    json_object = load_json_includes(json_object, animation_file_path)
    animation_file_info = parse_animation_file(json_object, animation_file_path)
    for animation_name in (
              frozenset(animation_file_info.gif_animations_to_export)
            | frozenset(animation_file_info.wml_animations_to_export)):
        animation_info = parse_animation(
            name_key            = animation_name,
            main_json_object    = json_object,
            animation_cache     = animation_cache,
            root_fallback_frame = animation_file_info.fallback_frame,
            gif_root_path       = animation_file_info.gif_root_path,
            wml_root_path       = animation_file_info.wml_root_path)
        animation_cache[animation_name] = animation_info
        animation_infos[animation_name] = animation_info

    return animation_file_info, animation_infos


def write_frame_wml(
        stream,
        frame_info : FrameInfo,
        path_variables : dict[str, str],
        indentation_level = 0,
        indentation_sequence = "    "):
    
    if frame_info.wml_duration <= 0:
        return

    unindented_prefix = indentation_sequence * indentation_level
    indented_prefix = indentation_sequence * (indentation_level + 1)

    def write_unindented_line(content):
        stream.write(f"{unindented_prefix}{content}\n")

    def write_indented_line(content):
        stream.write(f"{indented_prefix}{content}\n")

    def write_indented_value(key, value, default_value = None):
        if value is None or (default_value is not None and value == default_value):
            return
        write_indented_line(f"{key}={value}")

    abs_input_path = apply_path_variables(frame_info.wml_input_path, path_variables).abs()
    rel_input_path = os.path.relpath(abs_input_path, start=os.path.join(get_git_root(), "images"))

    write_unindented_line(f"[{frame_info.frame_label()}]")
    write_indented_line(f"image=\"{rel_input_path}\"")
    write_indented_line(f"duration={frame_info.wml_duration}")
    write_indented_value("x",             frame_info.offset[0],             default_value = 0)
    write_indented_value("y",             frame_info.offset[1],             default_value = 0)
    write_indented_value("directional_x", frame_info.directional_offset[0], default_value = 0)
    write_indented_value("directional_y", frame_info.directional_offset[1], default_value = 0)
    write_indented_value("opacity",       frame_info.opacity,               default_value = 1.0)
    for key, value in frame_info.other_wml_info.items():
        write_indented_line(f"{key}={value}")
    write_unindented_line(f"[/{frame_info.frame_label()}]")


def write_animation_wml(
        stream,
        animation_info : AnimationInfo,
        path_variables : dict[str, str],
        indentation_level = 0,
        indentation_sequence = "    "):
    unindented_prefix = indentation_sequence * indentation_level
    indented_prefix = indentation_sequence * (indentation_level + 1)

    def write_unindented_line(content):
        stream.write(f"{unindented_prefix}{content}\n")
    def write_indented_line(content):
        stream.write(f"{indented_prefix}{content}\n")

    if animation_info.start_time != 0:
        write_indented_line(f"start_time={animation_info.start_time}")
    for frame_info in animation_info.frames:
        write_frame_wml(stream, frame_info, path_variables, indentation_level + 1, indentation_sequence)


def write_wml_animation_file(
        animation_info      : AnimationInfo,
        animation_file_path : SplitPath,
        path_variables      : dict[str, str],
        update_only         : bool = False):
    automatic_path_variables = make_automatic_path_variables(
        name                = animation_info.name,
        number_of_frames    = len(animation_info.frames),
        animation_file_path = animation_file_path,
        gif_output_path     = animation_info.gif_output_path,
        wml_output_path     = animation_info.wml_output_path)
    path_variables = {**automatic_path_variables, **path_variables}

    output_path = apply_path_variables(animation_info.wml_output_path, path_variables)
    if update_only and get_time(output_path.abs()) > get_time(animation_file_path.abs()):
        print(f"Up-to-date: {output_path.str()}")
        return
    print(f"Creating: {output_path.str()}")

    os.makedirs(output_path.abs("mid"), exist_ok=True)
    with open(output_path.abs(), "wt") as stream:
        write_animation_wml(stream, animation_info, path_variables)


@dataclass
class GifFrameInfo:
    image              : Image
    duration           : int
    offset             : tuple[int, int]


def translate_image(image : Image, offset):
    match offset:
        case (0, 0):
            return
        case (x, y):
            raise NotImplementedError("Cannot align gif frames of different size and offset yet.")
        case value:
            raise ValueError("Offset must be a tuple of two integers not {type(value)}")


def make_gif(gif_frames : list[GifFrameInfo], output_path : str):
    if not gif_frames:
        return

    images    = [gif_frame.image    for gif_frame in gif_frames]
    durations = [gif_frame.duration for gif_frame in gif_frames]
    offsets   = [gif_frame.offset   for gif_frame in gif_frames]

    size = images[0].size
    for (image, offset) in zip(images, offsets):
        if image.size != size:
            raise NotImplementedError("Cannot align gif frames of different size and offset yet.")
        translate_image(image, offset)

    images[0].save(output_path,
                   save_all=True,
                   append_images=images[1:],
                   duration=durations,
                   disposal=2,       # restore background color
                   loop=0,           # loop forever
                   optimize=True)    # remove unused colors


def write_gif_animation_file(
        animation_info      : AnimationInfo,
        animation_file_path : SplitPath,
        path_variables      : dict[str, str],
        update_only         : bool = False):
    name = animation_info.name
    automatic_path_variables = make_automatic_path_variables(
        name                = name,
        number_of_frames    = len(animation_info.frames),
        animation_file_path = animation_file_path,
        gif_output_path     = animation_info.gif_output_path,
        wml_output_path     = animation_info.wml_output_path)
    path_variables = {**automatic_path_variables, **path_variables}

    output_path = apply_path_variables(animation_info.gif_output_path, path_variables)
    output_file_time = get_time(output_path.abs())
    input_file_times = [ get_time(animation_file_path.abs()) ]
    frame_input_paths = []
    for frame in animation_info.frames:
        frame_input_path = apply_path_variables(frame.gif_input_path, path_variables).abs()
        frame_input_paths.append(frame_input_path)
        input_file_times.append(get_time(frame_input_path))

    if update_only and all(output_file_time > input_file_time for input_file_time in input_file_times):
        print(f"Up-to-date: {output_path.str()}")
        return
    print(f"Creating: {output_path.str()}")

    os.makedirs(output_path.abs("mid"), exist_ok=True)
    def add_offsets(lhs, rhs): return (lhs[0] + rhs[0], lhs[1] + rhs[1])
    gif_frame_infos = [GifFrameInfo(
            image    = Image.open(frame_input_path),
            duration = frame.gif_duration,
            offset   = add_offsets(frame.offset, frame.directional_offset))
        for (frame_input_path, frame) in zip(frame_input_paths, animation_info.frames) if frame.gif_duration > 0]
    make_gif(gif_frame_infos, output_path.abs())


def animate_file(
        animation_file_path : SplitPath,
        export_gif          : bool,
        export_wml          : bool,
        update_only         : bool):
    try:
        with open(animation_file_path.abs(), "rt") as json_stream:
            main_json_object = json.load(json_stream)
    except Exception as e:
        print(f"Could read and parse json file {str(animation_file_path)}:", e)
        return

    animation_file_info, animation_infos = parse_main(main_json_object, animation_file_path)
    if export_wml:
        for animation_name in animation_file_info.wml_animations_to_export:
            for path_variables in animation_file_info.wml_path_variable_variations:
                write_wml_animation_file(
                        animation_infos[animation_name],
                        animation_file_path,
                        path_variables,
                        update_only)

    if export_gif:
        for animation_name in animation_file_info.gif_animations_to_export:
            for path_variables in animation_file_info.gif_path_variable_variations:
                write_gif_animation_file(
                        animation_infos[animation_name],
                        animation_file_path,
                        path_variables,
                        update_only)


def animate_folder(
        input_path  : str,
        export_gif  : bool,
        export_wml  : bool,
        recursive   : bool,
        update_only : bool):
    split_input_back_paths = list_files_recursively(input_path, recursive, allowed_extension=".json")
    for split_input_back_path in split_input_back_paths:
        animate_file(split_input_back_path, export_gif, export_wml, update_only)


def run_animate(args):
    if not args.gif and not args.wml:
        (export_gif, export_wml) = (True, True)
    else:
        (export_gif, export_wml) = (args.gif, args.wml)

    animate_folder(args.input, export_gif, export_wml, args.recursive, args.update_only)


