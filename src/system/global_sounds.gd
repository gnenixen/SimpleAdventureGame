extends Node
class_name CGlobalSounds

@onready var snd_pickup: AudioStreamPlayer = $pickup;
@onready var snd_jump: AudioStreamPlayer = $jump;
@onready var snd_interact: AudioStreamPlayer = $interact;
@onready var snd_drop_item: AudioStreamPlayer = $drop_item;
@onready var snd_heal: AudioStreamPlayer = $heal;
@onready var snd_damage: AudioStreamPlayer = $damage;
@onready var snd_door_open: AudioStreamPlayer = $door_open;
@onready var snd_door_enter: AudioStreamPlayer = $door_enter;
@onready var snd_alarm: AudioStreamPlayer = $alarm;
@onready var snd_ui_open: AudioStreamPlayer = $ui_open;

func _ready() -> void:
	StaticSignals.pickable_picked.connect(_on_pickable_picked);
	StaticSignals.player_hp_changed.connect(_on_player_hp_changed);

func _on_pickable_picked(_pickable: CPickable) -> void:
	snd_pickup.play();

func _on_player_hp_changed(old_hp: int, _old_max_hp: int, new_hp: int, _new_max_hp: int) -> void:
	if old_hp == new_hp:
		return;

	if old_hp < new_hp:
		snd_heal.play();
	else:
		snd_damage.play();
