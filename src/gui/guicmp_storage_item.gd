extends Control
class_name CGUICmpStorageItem

@export var icon: TextureRect;

var item_type: CItemType.EType;

func set_icon(texture: Texture) -> void:
    icon.texture = texture;