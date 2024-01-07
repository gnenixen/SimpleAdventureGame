extends CFuncItem
class_name CAmulet

func _register_actions() -> void:
    add_action("Use", _use);

func _use() -> void:
    GAPI.player.max_hp += 1;
    GAPI.player.hp -= 9;

