class_name CGUIManager

var mHandlerNode = null;
var mGUIs : Dictionary = {};

func Initialize():
	mHandlerNode = GAPI.NewHandlerNode("GUIManager_CanvasLayer", CanvasLayer);

func Register(guiName : String, gui) -> void:
	if gui is PackedScene:
		gui = gui.instantiate();

	mGUIs[guiName] = gui;

	gui.name = guiName;
	mHandlerNode.add_child(gui);

func Get(guiName : String) -> CGUIObject:
	assert(Has(guiName));

	return mGUIs[guiName];

func Has(guiName : String) -> bool:
	return mGUIs.has(guiName);
