extends Area2D
class_name CTriggerSceneChange

@export var scene_name: String;
@export var player_spawn_position_id: String;

func _on_body_entered(body: Node2D):
	if body is CPlayer:
		StaticSignals.player_enter_trigger_scene_change.emit(scene_name, player_spawn_position_id);
