#!/usr/bin/env python

import os

from PIL import Image

from .util import convert_path, newer_than

def animate_file(sprites_with_times, output_path, update_only=False):
    [paths, mstimes] = zip(*sprites_with_times)
    output_path = convert_path(output_path)
    paths = [convert_path(path) for path in paths]
    
    if update_only and newer_than(output_path, *paths):
        print(f"Up-to-date: {output_path}.")
        return

    images = [Image.open(path) for path in paths]
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    print(f"Creating: {output_path}")
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
    animate_file(sprites_with_times, args.output, update_only=args.update_only)