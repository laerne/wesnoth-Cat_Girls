import os.path
import re
import functools
from typing import Any, Callable

from PIL import Image

@functools.cache
def get_root():
    import subprocess
    try:
        return subprocess.check_output(["git", "rev-parse", "--show-toplevel"], encoding = 'utf8')[:-1]
    except (FileNotFoundError, CalledProcessError):
        dn = os.path.dirname
        return dn(dn(dn(dn(__file__))))
    
def _newer_than(candidate_path, *comparison_paths):
    "Return true if candidate path is newer than every path in comparisons_path."
    try:
        candidate_mtime = os.path.getmtime(candidate_path)
    except OSError:
        return False
    try:
        return all(candidate_mtime > os.path.getmtime(path) for path in comparison_paths)
    except OSError:
        raise OSError("Some input files are non-existant.")
    
def newer_than(candidate_path, *comparison_paths):
    result = _newer_than(candidate_path, *comparison_paths)
    return result

def save_image(image, path):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    image.save(path)

def noop(*args, **kwargs):
    pass

def human_sorted_key(text):
    return [int(word) if word.isdigit() else word for word in re.split("(\\d+)", text)]

def human_sorted(strings):
    return sorted(strings, key=human_sorted_key)

def convert_path(path : str):
    if path.startswith((":/", ":\\")):
        return os.path.join(get_root(), path[2:])
    else:
        return path

def transform_files_recursively(
        input_path : str,
        output_path : str,
        transform_file_cb : Callable[Any, [str, str]],
        output_suffix : str = "",
        output_extension = None,
        allowed_extension = (".png", ".jpg", ".jpeg"),
        verbosity = 'file',
        update_only = False,
        ):
    input_path  = convert_path(input_path)
    output_path = convert_path(output_path)

    if os.path.isfile(input_path):
        output_base, output_ext = os.path.splitext(output_path)
        if output_extension is not None: output_ext = output_extension
        output_path = f"{output_base}{output_suffix}{output_ext}"
        transform_file_cb(input_path, output_path)
    elif os.path.isdir(input_path):
        for input_folder, subfolders, subfiles in os.walk(input_path):
            if not subfiles:
                continue
            relative_folder = os.path.relpath(input_folder, input_path)
            output_folder = os.path.join(output_path, relative_folder)
            for input_file in human_sorted(subfiles):
                if allowed_extension and not input_file.endswith(allowed_extension):
                    continue
                file_basename, file_ext = os.path.splitext(input_file)
                if output_extension is not None: file_ext = output_extension
                output_file = f"{file_basename}{output_suffix}{file_ext}"
                input_path  = os.path.join(input_folder,  input_file)
                output_path = os.path.join(output_folder, output_file)

                if update_only and newer_than(output_path, input_path):
                    if verbosity == 'file':
                        print(f"Up-to-date: {output_path}")
                    continue
                
                if verbosity == 'file':
                    if output_file != input_file:
                        print(f"Transforming: {input_path}\nto: {output_path}...")
                    else:
                        print(f"Updating: {output_path}")
                transform_file_cb(input_path, output_path)
    else:
        raise ValueError(f"{input_path} is neither an existing file nor an existing directory")

