from krita import *

class MyExtension(Extension):
    def __init__(self, parent):
        super().__init__(parent)
    
    def setup(self):
        pass

    def createActions(self, window):
        export_action = window.createAction("wesnoth_sprite_exporter.export", "Export Wesnoth Sprites", "tools/scripts")
        return [export_action]