import argparse
import sys
from .teamcolor import *
from .recolor import *
from .krautil import *
from .animate import *

def parse_args(argv):
    
    def add_input_output_args(parser):
        parser.add_argument('-i', '--input', action='store', required=True, metavar='PATH',
                help='File to edit. Can be a folder, in which case all valid subfiles of that folder will be edited, recursively.')
        parser.add_argument('-o', '--output', action='store', required=True, metavar='PATH',
                help='Where to write the edited file. Must be a folder if --input was provided with a folder.')
        parser.add_argument('-r', '--recursive', action='store_true', default=False, 
                help="Recurse into input folder to find files to work on.")

    def add_update_only_arg(parser, strong_option=False):
        parser.add_argument('-U', '--update-only', action='store_true', default=False, 
                help="Only update out of date files (instead of recomputing them all)")
        if strong_option:
            parser.add_argument('--strong-update-only', action='store_true', default=False,
                    help="Do not erase out of date files if they would be replace by exactly the same content. Implies --update-only.")
    
    parser = argparse.ArgumentParser(
            prog='sprite_manager',
            description='automate transformation of sprites')
    subparsers = parser.add_subparsers(required=True, dest='subcommand')

    teamcolors = [str(color).lower().removeprefix("base ").replace(" ", "") for color in Color]
    recolor_parser = subparsers.add_parser('recolor',
            help='Recolor a specific subset of colors of a sprite to another.')
    add_input_output_args(recolor_parser)
    add_update_only_arg(recolor_parser, strong_option=True)
    recolor_parser.add_argument('-f', '--from', action='store', metavar="COLOR[,COLOR...]",
            help='What color palette to change from. Multiple colors can be specified by separating them by commas.')
    recolor_parser.add_argument('-t', '--to', action='append', default=[], required=True, metavar="COLOR[,COLOR...]",
            help='What color palette to change to. As many colors must be specified per --to option than the --from option has. Multiple --to can be specified.')
    recolor_parser.add_argument('-F', '--color-folders', action='store_true', default=False,
            help='Separate output files into colors folders. If there are more than one color per --to argument, it is mandatory to specify either -F or -S.')
    recolor_parser.add_argument('-S', '--color-suffixes', action='store_true', default=False,
            help='Add colors suffixes in output names. If there are more than one color per --to argument, it is mandatory to specify either -F or -S.')

    animate_parser = subparsers.add_parser('animate', help='Animate several frames file into a gif file.')
    add_update_only_arg(animate_parser)
    animate_parser.add_argument('-f', '--frame', action='extend', nargs='+', required=True,
            help='Frame of animation. Must be provided for each frame, in order.')
    animate_parser.add_argument('-d', '--delay', action='extend', nargs='+', default=[],
            help='Delay of each frame in milliseconds. Must be provided only once or for each frame, in the same order.')
    animate_parser.add_argument('-o', '--output', action='store', required=True, metavar='PATH',
            help='Where to write the edited file.')
    #animate_parser.add_argument('-J', '--json', action='store', required=True, metavar='PATH',
    #        help='Where to write the edited file.')

    kra_parser = subparsers.add_parser('kra', help='''Handle krita files. Command 'krita' must be in ${PATH}.''')
    add_update_only_arg(kra_parser, strong_option=True)
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

