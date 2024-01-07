extends IGameState
class_name CGameState_DoorLock

func on_push(args: Array) -> void:
	assert(args.size() > 0);
	assert(args[0] is CDoorLock);

	var gui: CGUIDoorLock = GAPI.gui_get(CGUIList.EGUI.DOOR_LOCK);
	gui.display_door_lock(args[0]);
	gui.visible = true;
	GAPI.get_tree().paused = true;
	GlobalSounds.snd_ui_open.play();

func on_pop() -> void:
	var gui: CGUIDoorLock = GAPI.gui_get(CGUIList.EGUI.DOOR_LOCK);
	gui.visible = false;
	GAPI.get_tree().paused = false;
