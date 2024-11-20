#!/usr/bin/env python

import os

from PIL import Image

from .util import convert_path

def animate_file(sprites_with_times, output_path):
    [files, mstimes] = zip(*sprites_with_times)
    images = [Image.open(convert_path(file)) for file in files]
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    print(f"Animating files into {output_path}")
    images[0].save(output_path,
                   save_all=True,
                   append_images=images[1:],
                   duration=mstimes,
                   disposal=2,       # restore background color
                   loop=0,           # loop forever
                   optimize=True,    # remove unused colors
                   )

def run_animate(args):
    number_of_frames = len(args.frame)
    if len(args.delay) == 0:
        delays = [200] * number_of_frames
    elif len(args.delay) == number_of_frames:
        delays = [int(delay) for delay in args.delay]
    elif len(args.delay) == 1:
        delays = [int(args.delay[0])] * number_of_frames
    else:
        raise ValueError("If specified, --delay must be specified once or specified as many times as --frame")
    sprites_with_times = list(zip(args.frame, delays))
    animate_file(sprites_with_times, args.output)