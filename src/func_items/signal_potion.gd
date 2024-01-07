extends CFuncItem
class_name CSignalPotion

func _register_actions() -> void:
    add_action_with_remove_after_use("Drink", _use);

func _use() -> void:
    var door_looks: Array = GAPI.get_tree().get_nodes_in_group(CEnums.EGroups.DOORS_LOCKS);
    for i in door_looks:
        if i is CDoorLock:
            i.lock();
    
    GlobalSounds.snd_alarm.play();
