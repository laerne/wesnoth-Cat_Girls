# BBD's Krita Script Starter Feb 2018

import os
import os.path
import re
import sys

from .dsl import *

try:
    from krita import *
    app = Krita.instance()
except ImportError:
    Extension = object
    app = None
    print("//!!\\\\ Could not import krita.", file=sys.stderr)

EXTENSION_ID = 'pykrita_wesnoth_sprite_exporter'
MENU_ENTRY = 'Wesnoth Sprite Exporter'


def isNone(value):
    if isinstance(value, (list, tuple)):
        return any(elem is None for elem in value)
    else:
        return value is None


def parseRectValue(rectStr):
    m = re.fullmatch(r" *(?P<width>[0-9]+) *x *(?P<height>[0-9]+) *\+ *(?P<x>[0-9]+) *\+ *(?P<y>[0-9]+) *", rectStr)
    if m:
        x = int(m.group("x"))
        y = int(m.group("y"))
        w = int(m.group("width"))
        h = int(m.group("height"))
        return x, y, w, h
    else:
        print(f"Invalid rectangle argument {repr(rectStr)}. It must have the form '<width>x<height>+<x>+<y>' for integers <width>, <height>, <x>, <y>.")
        return None, None, None, None

# A Skipped Layer DOES NOT MEAN its children will be skipped.
class LayerIterable:
    def __init__(self, root, skipRoot, skipPattern):
        match root:
            case Document():
                self.rootLayer = root.rootNode()
            case Node():
                self.rootLayer = root
            case _:
                raise ValueError("`root` must be a krita.Document or a krita.Node")
        self.skipRoot = skipRoot
        self.skipPattern = re.compile(skipPattern)
    
    def _shouldSkipLayer(self, layer):
        return layer is None or self.skipRoot and layer == self.rootLayer or self.skipPattern.fullmatch(layer.name())

    def _iterAtLayer(self, layer):
        if not self._shouldSkipLayer(layer):
            yield layer
        if isinstance(layer, GroupLayer):
            for child in reversed(layer.childNodes()):
                yield from self._iterAtLayer(child)

    def __iter__(self):
        yield from self._iterAtLayer(self.rootLayer)

    def _iterAtLayerWithCallback(self, layer, callback):
        if not self._shouldSkipLayer(layer):
            recurse = callback(layer)
        else:
            recurse = None
        if recurse is None or recurse:
            if isinstance(layer, GroupLayer):
                for child in reversed(layer.childNodes()):
                    self._iterAtLayerWithCallback(child, callback)
    
    def iterWithCallback(self, callback):
        self._iterAtLayerWithCallback(self.rootLayer, callback)


def makeLayerPath(layer):
    current = layer
    path = []
    while current:
        path.insert(0, current.name())
        current = current.parentNode()
    return path[1:]

class WesnothSpriteExporter(Extension):

    def __init__(self, parent):
        super().__init__(parent) # Initialize underlying C++

    def setup(self):
        pass

    def createActions(self, window):
        action = window.createAction(EXTENSION_ID, MENU_ENTRY, "tools/scripts")
        action.triggered.connect(self.iterativeExport)

    def pickCurrentDocument(self):
        self.currentDocument = app.activeDocument()
        self.documentIterable = LayerIterable(self.currentDocument, skipRoot=True, skipPattern="No Name")

    def backupVisibilities(self):
        self.visibilities = {}
        for layer in self.documentIterable:
            self.visibilities[layer.uniqueId()] = layer.visible()
            
    def restoreVisibilities(self):
        for layer in self.documentIterable:
            visible = self.visibilities.get(layer.uniqueId(), False)
            layer.setVisible(visible)

    def loadLayerIdentifierInfo(self):
        self.identifierInfos = {}
        for layer in self.documentIterable:
            info = parse_identifier_name(layer.name())
            self.identifierInfos[layer.uniqueId()] = info

    def loadIterationInfo(self):
        documentFileName = self.currentDocument.fileName()
        base, ext = os.path.splitext(documentFileName)
        wseFile = base + "-wse.txt"
        with open(wseFile) as wseStream:
            wseString = wseStream.read()
        self.iterationInfo = parse_iteration_instruction(wseString)

    def exportForTags(self, path, tags):
        print(f"Exporting for tags {tags}...")

        def setHideLayerAccordinglyToTags(layer):
            uid = layer.uniqueId()
            identifierInfo = self.identifierInfos[uid]
            visible = identifierInfo.match_tags(tags)
            layer.setVisible(visible)
            # print(f"  Layer {'  '.join(makeLayerPath(layer))} would be {'VISIBLE' if visible else 'hidden'}.")
            # print(f"  layer tags = {[subinfo.tags for subinfo in identifierInfo.subinfos]}")
            # if visible: print(f"  ...will show layer {'  '.join(makeLayerPath(layer))}")
            return visible
        
        clonedDocument = self.currentDocument.clone()
        clonedDocumentIterable = LayerIterable(clonedDocument, skipRoot=True, skipPattern="No Name")
        clonedDocumentIterable.iterWithCallback(setHideLayerAccordinglyToTags)

        if "+CROP" in tags:
            x, y, w, h = parseRectValue(tags["+CROP"])
            if not isNone((x, y, w, h)):
                clonedDocument.crop(x, y, w, h)
                

        path += ".kra"
        print(f"Exporting to filename {repr(path)}...")
        
        if not os.path.isabs(path):
            documentFileName = self.currentDocument.fileName()
            path = os.path.join(os.path.dirname(documentFileName), path)
        folder = os.path.dirname(path)
        os.makedirs(folder, exist_ok=True)
        clonedDocument.setBatchmode(True)
        clonedDocument.waitForDone()
        clonedDocument.saveAs(path)
        clonedDocument.close()

    def iterativeExport(self):
        self.pickCurrentDocument()

        previousBatchMode = self.currentDocument.batchmode()
        self.backupVisibilities()
        try:
            self.currentDocument.setBatchmode(True)

            self.loadIterationInfo()
            self.loadLayerIdentifierInfo()
            for path, tags in self.iterationInfo:
                self.exportForTags(path, tags)
        finally:
            self.restoreVisibilities()
            self.currentDocument.setBatchmode(previousBatchMode)

