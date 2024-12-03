import os
import subprocess
from .util import noop, transform_files_recursively

def run_krita(*args : list[str]):
    completion = subprocess.run(['krita', *args])
    return completion

def convert_kra(input_file : str, output_file : str):
    os.makedirs(os.path.dirname(output_file), exist_ok=True)
    run_krita('--export', input_file, '--export-filename', output_file)

def convert_kra_folder(input_path : str, output_path : str, update_only : bool = False):
    transform_files_recursively(
        input_path,
        output_path,
        convert_kra,
        output_extension = ".png",
        allowed_extension = (".kra",),
        update_only=update_only,
        )

def run_kra(args):
    convert_kra_folder(args.input, args.output, update_only=args.update_only)
    

