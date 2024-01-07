extends Resource
class_name CResourceItem

@export var name: String = "Item";
@export_multiline var description: String = "ItemDescription";
@export var type: CItemType.EType;
@export var icon: Texture;
@export var item_scene: PackedScene;
@export_file("*.gd") var func_script_file: String;