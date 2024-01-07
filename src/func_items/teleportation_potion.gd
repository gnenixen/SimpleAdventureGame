extends CFuncItem
class_name CTeleportationPotion

func _register_actions() -> void:
    add_action_with_remove_after_use("Drink", _use);

func _use() -> void:
    pass
