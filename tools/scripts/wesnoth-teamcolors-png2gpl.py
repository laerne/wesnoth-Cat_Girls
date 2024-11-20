from PIL import Image

_primary_color_names = [
    "Base Pink",
    "Red",
    "Blue",
    "Green",
    "Purple",
    "Black",
    "Brown",
    "Orange",
    "White",
    "Teal",
    "Light Red",
    "Dark Red",
    "Light Blue",
    "Bright Green",
    "Bright Orange",
    "Gold",
]

_secondary_color_names = [
    "Base Cyan",
    "Indigo",
    "Sky Blue",
    "Sun Yellow",
]

def generate_teamcolor_gpl(source, destination, color_names = _primary_color_names, title = ""):
    with Image.open(source) as image:
        with open(destination, "wt") as swatch:
            if not title: title = "Wesnoth Team Colors\n"
            if not title.endswith("\n"): title += "\n"
            swatch.write("GIMP Palette\n")
            swatch.write(f"Name: {title}")
            swatch.write(f"Columns: {image.width}\n\n")
            pixels = image.convert(mode = "RGB").load()
            for j in range(image.height):
                for i in range(image.width):
                    tint_name = color_names[j] if 0 <= j < len(color_names) else "Color of Shade"
                    r, g, b = pixels[i, j]
                    swatch.write(f"{r} {g} {b} {tint_name} {i+1}\n")

if __name__ == '__main__':
    import os.path
    import sys
    argc = len(sys.argv)
    color_names = _primary_color_names
    title = ""

    if argc <= 1:
        scripts_dir = os.path.dirname(__file__)
        assets_dir = os.path.join(os.path.dirname(scripts_dir), "assets")
        source = os.path.join(assets_dir, "wesnoth-teamcolors.png")
        destination = os.path.join(assets_dir, "wesnoth-teamcolors.gpl")
    elif argc == 2:
        source = sys.argv[1]
        destination = os.path.splitext(sys.argv[1])[0] + '.gpl'
    elif argc == 3:
        source = sys.argv[1]
        destination = sys.argv[2]
    elif argc == 4:
        source = sys.argv[1]
        destination = sys.argv[2]
        color_palette_name = sys.argv[3]
        if color_palette_name == "primary":
            color_names = _primary_color_names
            title = "Wesnoth Primary Team Colors\n"
        elif color_palette_name == "secondary":
            color_names = _secondary_color_names
            title = "Wesnoth Secondary Team Colors\n"
        elif color_palette_name == "primary+secondary":
            color_names = _primary_color_names + _secondary_color_names
            title = "Wesnoth Primary & Secondary Team Colors\n"
    else:
        print("Too many arguments", file=sys.stderr)
        sys.exit(1)
    print("from:", source)
    print("to:", destination)
    generate_teamcolor_gpl(source, destination, color_names = color_names, title = title)
