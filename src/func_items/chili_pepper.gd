extends CFuncItem
class_name CChiliPepper

func _register_actions() -> void:
    add_action_with_remove_after_use("Eat", _use);

func _use() -> void:
    GAPI.player.hp -= 1;
