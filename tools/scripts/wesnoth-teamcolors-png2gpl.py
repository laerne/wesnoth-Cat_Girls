from PIL import Image

with open("colorswatch.gpl", "wt") as swatch:
    swatch.write("GIMP Palette\n")
    swatch.write("Name: Wesnoth Team Colors\n")
    swatch.write("Columns: 10\n\n")
    with Image.open("colorswatchPXL.png") as image:
        pixels = image.convert(mode = "RGB").load()
        for i in range(19):
            for j, tint_name in enumerate(["Red", "Blue", "Green", "Purple", "Orange", "Black", "White", "Brown", "Cyan", "Base Pink"]):
                r, g, b = pixels[i, j]
                swatch.write(f"{r} {g} {b} {tint_name} {i+1}\n")
