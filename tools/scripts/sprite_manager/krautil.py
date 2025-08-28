import os
import subprocess
import tempfile
from .util import list_files_recursively, path_to_splitpath, get_time, image_equal, isdir

def run_krita(*args : list[str]):
    completion = subprocess.run(['krita', *args])
    return completion

def convert_kra(input_file : str, output_file : str, keep_old_files_on_equality = False):
    if output_file != input_file:
        print(f"Transforming: {input_file}\nto: {output_file}")
    else:
        print(f"Updating: {output_file}")
    os.makedirs(os.path.dirname(output_file), exist_ok=True)
    if keep_old_files_on_equality:
        output_dir, output_filename = os.path.split(output_file)
        with tempfile.TemporaryDirectory(dir = output_dir) as tmp_output_dir_mngr:
            tmp_output_file = os.path.join(tmp_output_dir_mngr, output_filename)
            run_krita('--export', input_file, '--export-filename', tmp_output_file)
            if not image_equal(tmp_output_file, output_file):
                os.replace(tmp_output_file, output_file)
    else:
        run_krita('--export', input_file, '--export-filename', output_file)

def convert_kra_folder(
        input_path : str,
        output_path : str,
        recursive : bool = False,
        update_only : bool = False,
        keep_old_files_on_equality = False):
    split_input_back_paths = list_files_recursively(input_path, recursive, allowed_extension=".kra")
    split_output_path = path_to_splitpath(output_path, nonexistant_is_dir = isdir(input_path))
    for split_input_back_path in split_input_back_paths:
        split_output_back_path = split_output_path                                             \
            .replaced_with(mid = split_input_back_path.mid, back = split_input_back_path.back) \
            .with_back_extension(".png")

        if update_only and get_time(split_input_back_path) <= get_time(split_output_back_path):
            print(f"Up-to-date: {str(split_output_back_path)}")
            continue
        convert_kra(split_input_back_path.abs(), split_output_back_path.abs(), keep_old_files_on_equality)

def run_kra(args):
    convert_kra_folder(
        args.input,
        args.output,
        recursive=args.recursive,
        update_only=args.update_only or args.strong_update_only,
        keep_old_files_on_equality=args.strong_update_only)


