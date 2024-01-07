extends CFuncItem
class_name COrange

func _register_actions() -> void:
    add_action_with_remove_after_use("Eat", _use);

func _use() -> void:
    GAPI.player.max_hp += 1;
    GAPI.player.hp += 1;
