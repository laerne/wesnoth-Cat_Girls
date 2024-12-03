import argparse
import sys
from .teamcolor import *
from .recolor import *
from .krautil import *
from .animate import *

def parse_args(argv):
    
    def add_input_output_args(parser):
        input_arg = parser.add_argument('-i', '--input', action='store', required=True, metavar='PATH',
                help='File to edit. Can be a folder, in which case all valid subfiles of that folder will be edited, recursively.')
        output_arg = parser.add_argument('-o', '--output', action='store', required=True, metavar='PATH',
                help='Where to write the edited file. Must be a folder if --input was provided with a folder.')
        return input_arg, output_arg
    
    parser = argparse.ArgumentParser(
            prog='sprite_manager',
            description='automate transformation of sprites')
    parser.add_argument('-U', '--update-only', action='store_true', default=False, 
            help="Only update out of date files (instead of recomputing them all)")
    subparsers = parser.add_subparsers(required=True, dest='subcommand')

    teamcolors = [str(color).lower().removeprefix("base ").replace(" ", "") for color in Color]
    recolor_parser = subparsers.add_parser('recolor',
            help='Recolor a specific subset of colors of a sprite to another.')
    add_input_output_args(recolor_parser)
    recolor_parser.add_argument('-f', '--from', action='store', metavar="COLOR[,COLOR...]",
            help='What color palette to change from. Multiple --from can be specified.')
    recolor_parser.add_argument('-t', '--to', action='append', default=[], required=True, metavar="COLOR[,COLOR...]",
            help='What color palette to change to. Must be use as many times as --from is used. Each --to must specify the same number of colors.')
    recolor_parser.add_argument('-F', '--color-folders', action='store_true', default=False,
            help='Separate output files into colors folders. If there are more than one color per --to argument, it is mandatory to specify either -F or -S.')
    recolor_parser.add_argument('-S', '--color-suffixes', action='store_true', default=False,
            help='Add colors suffixes in output names. If there are more than one color per --to argument, it is mandatory to specify either -F or -S.')

    animate_parser = subparsers.add_parser('animate', help='Animate several frames file into a gif file.')
    animate_parser.add_argument('-f', '--frame', action='extend', nargs='+', required=True,
            help='Frame of animation. Must be provided for each frame, in order.')
    animate_parser.add_argument('-d', '--delay', action='extend', nargs='+', default=[],
            help='Delay of each frame in milliseconds. Must be provided only once or for each frame, in the same order.')
    animate_parser.add_argument('-o', '--output', action='store', required=True, metavar='PATH',
            help='Where to write the edited file.')

    kra_parser = subparsers.add_parser('kra', help='''Handle krita files. Command 'krita' must be in ${PATH}.''')
    add_input_output_args(kra_parser)

    return parser.parse_args(argv)

def run(args):
    match args.subcommand:
        case "kra":
            run_kra(args)
        case "recolor":
            run_recolor(args)
        case "animate":
            run_animate(args)

def main():
    args = parse_args(sys.argv[1:])
    return_code = run(args)
    return return_code

