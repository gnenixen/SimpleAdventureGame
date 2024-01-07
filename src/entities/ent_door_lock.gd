extends StaticBody2D
class_name CDoorLock

@export var is_locked: bool = true;

var _initial_collision_layer: int;
var _initial_collision_mask: int;

func _init() -> void:
	_initial_collision_layer = collision_layer;
	_initial_collision_mask = collision_mask;

func _ready() -> void:
	add_to_group(CEnums.EGroups.DOORS_LOCKS);

	set_collision_active(is_locked);

func lock() -> void:
	set_collision_active(true);

func unlock() -> void:
	GlobalSounds.snd_door_open.play();
	set_collision_active(false);

func set_collision_active(value: bool) -> void:
	is_locked = value;
	visible = value;

	if value:
		collision_layer = _initial_collision_layer;
		collision_mask = _initial_collision_mask;
	else:
		collision_layer = 0;
		collision_mask = 0;

func _on_unlock_area_body_entered(body: Node2D):
	if body is CPlayer && is_locked:
		StaticSignals.player_enter_trigger_door_unlock.emit(self);
