extends CGUIObject
class_name CGUIDoorLock

@export var yes_button: Button;
@export var no_button: Button;

var _current_door_lock: CDoorLock;

func _ready() -> void:
	visible = false;

func display_door_lock(door_lock: CDoorLock) -> void:
	_current_door_lock = door_lock;

	yes_button.disabled = GAPI.player.keys == 0;

	if yes_button.disabled:
		no_button.grab_focus();
	else:
		yes_button.grab_focus();

func _on_yes_pressed():
	_current_door_lock.unlock();
	GAPI.player.keys -= 1;
	GAPI.GameState_Pop();

func _on_no_pressed():
	GAPI.GameState_Pop();
