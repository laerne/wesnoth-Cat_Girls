#!/usr/bin/env python

import os
import sys

from PIL import Image

def animation_data_from_folder(
        prefix,
        suffixes,
        mstimes,
        *,
        extension = ".png"):
    assert len(suffixes) == len(mstimes)
    assert len(suffixes) > 0
    data = [(prefix + suffix + extension, mstime) for suffix, mstime in zip(suffixes, mstimes)]
    return data


def save_image(image, path):
    image.save(path)


def animate(animation_data, output_path):
    [files, mstimes] = zip(*animation_data)
    images = [Image.open(file) for file in files]
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    print(f"Animating files into {output_path}")
    images[0].save(output_path,
                   save_all=True,
                   append_images=images[1:],
                   duration=mstimes,
                   disposal=2,
                   loop=0,
                   optimize=False, 
                   )

def get_root():
    import subprocess
    return subprocess.check_output(["git", "rev-parse", "--show-toplevel"], encoding = 'utf8')[:-1]


def main():
    root = get_root()


    for color in ["red", "blue", "green", "purple", "orange", "black", "white", "brown", "cyan"]:
        chakram_warrior_standing_data = animation_data_from_folder(
                f"{root}/images-recolored/{color}/units/feu-ra/chakram_fighters/chakram_warrior",
                ['', *(f"+stand{k}" for k in range(1, 10))],
                [200] * 10)
        chakram_warrior_standing_gif_path = f"{root}/images-recolored/{color}/units/feu-ra/chakram_fighters/chakram_warrior.gif"
        animate(chakram_warrior_standing_data, chakram_warrior_standing_gif_path)



if __name__ == '__main__':
    main()
