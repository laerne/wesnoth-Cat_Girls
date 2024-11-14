import os
import sys
from enum import Enum, auto

from PIL import Image

class Color(Enum):
    Pink   = auto(),
    Red    = auto(),
    Blue   = auto(),
    Green  = auto(),
    Purple = auto(),
    Orange = auto(),
    Black  = auto(),
    White  = auto(),
    Brown  = auto(),
    Cyan   = auto()

Color.pinks = [
    (63, 0, 22),
    (85, 0, 42),
    (105, 0, 57),
    (123, 0, 69),
    (140, 0, 81),
    (158, 0, 93),
    (177, 0, 105),
    (195, 0, 116),
    (214, 0, 127),
    (236, 0, 140),
    (238, 61, 150),
    (239, 91, 161),
    (241, 114, 172),
    (242, 135, 182),
    (244, 154, 193),
    (246, 173, 205),
    (248, 193, 217),
    (250, 213, 229),
    (253, 233, 241),
]

Color.reds = [
    (36, 0, 0),
    (54, 0, 0),
    (69, 0, 0),
    (82, 0, 0),
    (94, 0, 0),
    (107, 0, 0),
    (121, 0, 0),
    (133, 0, 0),
    (146, 0, 0),
    (161, 0, 0),
    (192, 0, 0),
    (210, 0, 0),
    (226, 0, 0),
    (240, 0, 0),
    (255, 0, 0),
    (255, 48, 48),
    (255, 96, 96),
    (255, 145, 145),
    (255, 197, 197),
]

Color.blues = [
    (19, 22, 34),
    (21, 25, 44),
    (23, 28, 53),
    (25, 31, 60),
    (26, 33, 66),
    (28, 36, 73),
    (29, 38, 81),
    (31, 41, 88),
    (32, 43, 95),
    (34, 46, 103),
    (38, 52, 120),
    (40, 56, 130),
    (42, 59, 139),
    (44, 62, 147),
    (46, 65, 155),
    (85, 101, 173),
    (125, 137, 192),
    (164, 173, 211),
    (208, 212, 232),
]

Color.greens = [
    (13, 25, 14),
    (20, 38, 21),
    (26, 49, 27),
    (31, 59, 32),
    (36, 67, 37),
    (41, 76, 42),
    (46, 86, 47),
    (51, 95, 52),
    (56, 104, 57),
    (62, 115, 63),
    (74, 137, 75),
    (81, 150, 82),
    (87, 161, 88),
    (92, 171, 94),
    (98, 182, 100),
    (127, 195, 129),
    (157, 209, 158),
    (187, 223, 188),
    (219, 238, 220),
]

Color.purples = [
    (20, 0, 22),
    (31, 0, 33),
    (40, 0, 43),
    (47, 0, 51),
    (54, 0, 58),
    (61, 0, 66),
    (70, 0, 74),
    (76, 0, 82),
    (84, 0, 90),
    (93, 0, 99),
    (111, 0, 118),
    (121, 0, 129),
    (130, 0, 139),
    (138, 0, 148),
    (147, 0, 157),
    (167, 48, 175),
    (187, 96, 194),
    (208, 145, 212),
    (230, 197, 233),
]

Color.oranges = [
    (49, 30, 12),
    (66, 38, 11),
    (80, 45, 10),
    (92, 51, 10),
    (103, 56, 9),
    (116, 61, 8),
    (129, 67, 7),
    (140, 73, 7),
    (152, 78, 6),
    (167, 85, 5),
    (196, 98, 3),
    (213, 106, 2),
    (228, 113, 1),
    (241, 119, 0),
    (255, 126, 0),
    (255, 150, 48),
    (255, 174, 96),
    (255, 199, 145),
    (255, 226, 197),
]

Color.blacks = [
    (12, 12, 12),
    (19, 19, 19),
    (24, 24, 24),
    (29, 29, 29),
    (33, 33, 33),
    (37, 37, 37),
    (42, 42, 42),
    (47, 47, 47),
    (51, 51, 51),
    (57, 57, 57),
    (68, 68, 68),
    (74, 74, 74),
    (79, 79, 79),
    (84, 84, 84),
    (90, 90, 90),
    (121, 121, 121),
    (152, 152, 152),
    (183, 183, 183),
    (218, 218, 218),
]

Color.whites = [
    (57, 57, 57),
    (71, 71, 71),
    (83, 83, 83),
    (93, 93, 93),
    (102, 102, 102),
    (112, 112, 112),
    (123, 123, 123),
    (131, 131, 131),
    (141, 141, 141),
    (153, 153, 153),
    (177, 177, 177),
    (191, 191, 191),
    (203, 203, 203),
    (214, 214, 214),
    (225, 225, 225),
    (230, 230, 230),
    (236, 236, 236),
    (242, 242, 242),
    (248, 248, 248),
]

Color.browns = [
    (21, 11, 5),
    (31, 17, 8),
    (40, 21, 10),
    (48, 25, 12),
    (54, 29, 14),
    (62, 33, 16),
    (70, 38, 18),
    (77, 41, 20),
    (84, 45, 22),
    (93, 50, 24),
    (111, 60, 29),
    (122, 66, 32),
    (131, 71, 34),
    (139, 75, 36),
    (148, 80, 39),
    (168, 113, 79),
    (188, 146, 120),
    (208, 179, 161),
    (231, 215, 206),
]

Color.cyans = [
    (6, 28, 27),
    (10, 43, 40),
    (13, 55, 52),
    (15, 65, 62),
    (17, 75, 71),
    (20, 85, 80),
    (22, 96, 91),
    (25, 106, 100),
    (27, 116, 110),
    (30, 128, 121),
    (36, 153, 145),
    (39, 167, 158),
    (42, 180, 170),
    (45, 191, 181),
    (48, 203, 192),
    (87, 212, 203),
    (126, 222, 215),
    (165, 232, 227),
    (208, 243, 240),
]

def get_color_values(color):
    color_name = color.name.lower() + 's'
    return getattr(Color, color_name)


def save_image(image, path):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    image.save(path)


def recolor(path_from, path_to, color_from, color_to):
    values_from = get_color_values(color_from)
    values_to   = get_color_values(color_to)
    assert len(values_from) == len(values_to)

    def recolor_pixels(image):
        pixels = image.load()
        for x in range(image.width):
            for y in range(image.height):
                r, g, b, a = pixels[x, y]
                if (r, g, b) not in values_from:
                    continue
                k = values_from.index((r, g, b))
                r, g, b = values_to[k]
                pixels[x, y] = r, g, b, a

    with Image.open(path_from) as image:
        rgba_image = image.convert("RGBA")
        recolor_pixels(rgba_image)
        save_image(rgba_image, path_to)

non_pink_colors = (Color.Red, Color.Blue, Color.Green, Color.Purple, Color.Orange, Color.Black, Color.White, Color.Brown, Color.Cyan)
def recolor_many(
        folder_path,
        recolored_folder_path,
        color_from=Color.Pink,
        colors_to=non_pink_colors):
    for folder, subfolders, subfiles in os.walk(folder_path):
        if not subfiles:
            continue
        relative_folder = os.path.relpath(folder, folder_path)
        for color_to in colors_to:
            color_name = color_to.name.lower()
            recolored_folder = os.path.join(recolored_folder_path, color_name, relative_folder)
            print(f"Recoloring images from {folder} to {recolored_folder}")
            for subfile in subfiles:
                recolor(
                    os.path.join(folder,           subfile),
                    os.path.join(recolored_folder, subfile),
                    color_from,
                    color_to)

def get_root():
    import subprocess
    return subprocess.check_output(["git", "rev-parse", "--show-toplevel"], encoding = 'utf8')[:-1]

if __name__ == '__main__':
    root = get_root()
    image_folder_path             = f"{root}/images"
    recolored_image_folder_path   = f"{root}/images-recolored"
    recolor_many(image_folder_path, recolored_image_folder_path)

