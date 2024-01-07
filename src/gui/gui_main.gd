extends CGUIObject
class_name CGUIMain

@export_group("Stats")
@export var stats_hp_stats_label: Label;
@export var stats_keys_stats_label: Label;

@export_group("Interactable Object")
@export var interactable_object_stats_label: Label;
@export var interactable_object_animator: AnimationPlayer;
@export var interactable_object_display_timer: Timer;

func _ready() -> void:
	stats_hp_stats_label.text = "0/0";
	stats_keys_stats_label.text = "0";

	interactable_object_display_timer.timeout.connect(_on_interactable_object_display_timer_timout);

	StaticSignals.player_hp_changed.connect(_on_player_hp_changed);
	StaticSignals.player_keys_changed.connect(_on_player_keys_changed);
	StaticSignals.interactable_interact_request.connect(_on_interactable_interact_request);

func _on_player_hp_changed(_old_hp: int, _old_max_hp: int, new_hp: int, new_max_hp: int) -> void:
	stats_hp_stats_label.text = str(new_hp, "/", new_max_hp);

func _on_player_keys_changed(new_keys: int) -> void:
	stats_keys_stats_label.text = str(new_keys);

func _on_interactable_interact_request(message: String) -> void:
	interactable_object_stats_label.text = message;

	if interactable_object_display_timer.time_left == 0.0:
		interactable_object_animator.play("show");

	interactable_object_display_timer.start();

func _on_interactable_object_display_timer_timout() -> void:
	interactable_object_animator.play_backwards("show");
	interactable_object_display_timer.stop();
