import os.path
import re
import functools
from typing import Any, Callable
from dataclasses import dataclass, field
from enum import Enum, auto
from PIL import Image, ImageChops

@functools.cache
def get_git_root():
    import subprocess
    try:
        return subprocess.check_output(["git", "rev-parse", "--show-toplevel"], encoding = 'utf8')[:-1]
    except (FileNotFoundError, CalledProcessError):
        dn = os.path.dirname
        return dn(dn(dn(dn(__file__))))


@functools.cache
def get_relative_root():
    return os.getcwd()


def get_time(path):
    if isinstance(path, SplitPath):
        path = path.abs()
    try:
        return os.path.getmtime(path)
    except OSError:
        return float("-inf")

def get_times(paths):
    match paths:
        case PathRoot() | str():
            return get_time(paths)
        case list():
            return [get_time(path) for path in paths]
        case tuple():
            return tuple(get_time(path) for path in paths)
        case set() | frozenset():
            return {path : get_time(path) for path in paths}


def image_equal(path_1, path_2):
    if not os.path.isfile(path_1) or not os.path.isfile(path_2):
        return False
    with Image.open(path_1) as image_1:
        with Image.open(path_2) as image_2:
            image_diff = ImageChops.difference(image_1, image_2)
            return not image_diff.getbbox()


def save_image(image, path, keep_old_files_on_equality=False):
    if isinstance(path, PathRoot): path = path.abs()
    if keep_old_files_on_equality and os.path.isfile(path):
        with Image.open(input_path) as old_image:
            old_to_new_image_diff = ImageChops.difference(image, old_image)
            if not old_to_new_image_diff.getbbox():
                return False

    os.makedirs(os.path.dirname(path), exist_ok=True)
    image.save(path)
    return True


def human_sorted_key(text):
    return [int(word) if word.isdigit() else word for word in re.split("(\\d+)", text)]


def human_sorted(strings):
    return sorted(strings, key=human_sorted_key)


class PathRoot(Enum):
    FileSystemRoot = auto()
    LocalFolderRoot = auto()
    GitRoot = auto()

    def path(self):
        match self:
            case PathRoot.FileSystemRoot:  return ""
            case PathRoot.LocalFolderRoot: return get_relative_root()
            case PathRoot.GitRoot:         return get_git_root()

    def str(self):
        match self:
            case PathRoot.FileSystemRoot:  return ""
            case PathRoot.LocalFolderRoot: return "."
            case PathRoot.GitRoot:         return ":"



@dataclass(slots=True, frozen=True)
class SplitPath:
    root  : PathRoot
    front : str
    mid   : str # Only nested directories
    back  : str # Filenames of regular files

    def abs(self, depth = "back"):
        match depth:
            case "root":  components = [self.root.path()]
            case "front": components = [self.root.path(), self.front]
            case "mid":   components = [self.root.path(), self.front, self.mid]
            case "back":  components = [self.root.path(), self.front, self.mid, self.back]
            case _: raise ValueError("Argument 'depth' must be any of 'root', 'front', 'mid' or 'back'")
        return os.path.join(*(component for component in components if component))

    def str(self, depth = "back"):
        match depth:
            case "root":  components = [self.root.str()]
            case "front": components = [self.root.str(), self.front]
            case "mid":   components = [self.root.str(), self.front, self.mid]
            case "back":  components = [self.root.str(), self.front, self.mid, self.back]
            case _: raise ValueError("Argument 'depth' must be any of 'root', 'front', 'mid' or 'back'")
        return os.path.join(*(component for component in components if component))

    def __str__(self):
        return self.str()

    def replaced_with(self, root = None, front = None, mid = None, back = None):
        if root  is None: root  = self.root
        if front is None: front = self.front
        if mid   is None: mid   = self.mid
        if back  is None: back  = self.back
        return SplitPath(root = root, front = front, mid = mid, back = back)

    def truncated(self, depth):
        match depth:
            case "root":  return SplitPath(root = self.root, front = "",         mid = "",       back = "")
            case "front": return SplitPath(root = self.root, front = self.front, mid = "",       back = "")
            case "mid":   return SplitPath(root = self.root, front = self.front, mid = self.mid, back = "")
            case "back":  return SplitPath(root = self.root, front = self.front, mid = self.mid, back = self.back)
            case _: raise ValueError("Argument 'depth' must be any of 'root', 'front', 'mid' or 'back'")

    def truncated_with(self, **kwargs):
        assert len(kwargs) == 1
        [(depth, component)] = kwargs.items()
        match depth:
            case "root":  return SplitPath(root = component, front = "",         mid = "",        back = "")
            case "front": return SplitPath(root = self.root, front = component,  mid = "",        back = "")
            case "mid":   return SplitPath(root = self.root, front = self.front, mid = component, back = "")
            case "back":  return SplitPath(root = self.root, front = self.front, mid = self.mid,  back = component)
            case _: raise ValueError("Argument name must be any of 'root', 'front', 'mid' or 'back'")

    def with_prepended_mid_folder(self, folder):
        return self.replaced_with(mid = os.path.join(folder, self.mid))

    def with_appended_mid_folder(self, folder):
        return self.replaced_with(mid = os.path.join(self.mid, folder))

    def with_back_suffix(self, name):
        basename, extname = os.path.splitext(self.back)
        return self.replaced_with(back = basename + name + extname)

    def with_back_extension(self, ext):
        basename, extname = os.path.splitext(self.back)
        return self.replaced_with(back = basename + ext)


def path_to_splitpath(path : str | SplitPath, nonexistant_is_dir : bool = False):
    if isinstance(path, SplitPath):
        return path

    if path.startswith((":/", ":\\")):
        root = PathRoot.GitRoot
        rel_path = path[2:]
    elif path.startswith(("/", "\\")):
        root = PathRoot.FileSystemRoot
        rel_path = path[1:]
    elif (len(path) > 0 and path[0] in "ABCDEFGHIJKLMNOPQRSTUVWXYZ" and path[1:3] == ":\\"):
        root = PathRoot.FileSystemRoot
        rel_path = path[3:]
    else:
        root = PathRoot.LocalFolderRoot
        rel_path = path

    abs_path = os.path.join(root.path(), rel_path)

    if os.path.isdir(abs_path):
        front_path, back_path = rel_path, ""
    elif os.path.isfile(abs_path):
        front_path, back_path = os.path.split(rel_path)
    elif nonexistant_is_dir:
        front_path, back_path = rel_path, ""
    else:
        front_path, back_path = os.path.split(rel_path)

    return SplitPath(root = root, front = front_path, mid = "", back = back_path)


def isdir(path : str | SplitPath, nonexistant_is_dir : bool = False):
    if isinstance(path, str):
        path = path_to_splitpath(path, nonexistant_is_dir)
    return os.path.isdir(path.abs())


def list_files_recursively(
        input_path : str,
        recursive: False,
        allowed_extension = (".png", ".jpg", ".jpeg")):

    split_input_path = path_to_splitpath(input_path)

    if os.path.isfile(split_input_path.abs()):
        return [split_input_path]
    elif os.path.isdir(split_input_path.abs()):
        assert split_input_path.back == ""
        result = []
        for input_folder, subfolders, subfiles in os.walk(split_input_path.abs()):
            if subfiles:
                input_mid_path = os.path.relpath(input_folder, start=split_input_path.abs())
                if input_mid_path == ".":
                    input_mid_path = ""
                split_input_mid_path = split_input_path.truncated_with(mid = input_mid_path)
                for subfile in human_sorted(subfiles):
                    if allowed_extension and not subfile.endswith(allowed_extension):
                        continue
                    result.append(split_input_mid_path.replaced_with(back = subfile))
            if not recursive:
                break
        return result
    else:
        raise ValueError("Input path is non existant or is not a regular file nor a directory")

