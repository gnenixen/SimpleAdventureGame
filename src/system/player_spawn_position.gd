@tool
extends Marker2D
class_name CPlayerSpawnPosition

@export var spawn_position_name: String:
    set(value):
        spawn_position_name = value;
        name = spawn_position_name;

func _ready() -> void:
    if !Engine.is_editor_hint():
        add_to_group(CEnums.EGroups.PLAYER_SPAWN_POSITIONS);