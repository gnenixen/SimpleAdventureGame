extends IGameState
class_name CGameState_Storage

func on_push(args: Array) -> void:
	StaticSignals.storage_display_request.connect(_on_storage_display_request);
	StaticSignals.player_die.connect(_on_player_die);

	assert(args.size() > 0);
	assert(args[0] is CStorage);

	var gui: CGUIStorage = GAPI.gui_get(CGUIList.EGUI.STORAGE);
	gui.display_storage(args[0]);
	gui.visible = true;
	GAPI.get_tree().paused = true;

func on_pop() -> void:
	StaticSignals.storage_display_request.disconnect(_on_storage_display_request);
	StaticSignals.player_die.disconnect(_on_player_die);

	var gui: CGUIStorage = GAPI.gui_get(CGUIList.EGUI.STORAGE);
	gui.visible = false;
	GAPI.get_tree().paused = false;

func _on_storage_display_request(_storage: CStorage):
	GAPI.GameState_Pop();

func _on_player_die() -> void:
	GAPI.restart_game();
