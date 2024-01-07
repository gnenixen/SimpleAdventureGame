extends CGUIObject

@export var animation_player : AnimationPlayer;

func play_open():
	animation_player.play("open");
	await animation_player.animation_finished;
	await get_tree().create_timer(0.3).timeout;

func play_close():
	animation_player.play_backwards("open");
	await animation_player.animation_finished;
