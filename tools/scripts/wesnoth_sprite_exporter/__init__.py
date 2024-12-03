from .wesnoth_sprite_exporter import app, WesnothSpriteExporter

if app is not None:
    # Instantiate your class:
    extension = WesnothSpriteExporter(parent = app)
    app.addExtension(extension)

