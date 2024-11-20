from .wesnoth_sprite_exporter import WesnothSpriteExporter

# And add the extension to Krita's list of extensions:
app = Krita.instance()
# Instantiate your class:
extension = WesnothSpriteExporter(parent = app)
app.addExtension(extension)
