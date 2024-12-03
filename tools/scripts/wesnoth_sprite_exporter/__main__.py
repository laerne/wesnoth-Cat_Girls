import sys
from .dsl import *

if __name__ != '__main__':
    print("Running __main__.py from import...", file=sys.stderr)
    sys.exit(1)

with open(sys.argv[1], "rt") as wse_stream:
    wse_text = wse_stream.read()
    wse_info = parse_iteration_instruction(wse_text)
    for cartesian_product_info in wse_info.cartesian_products:
        print(sorted(cartesian_product_info.tags.items()))