extends IGameState
class_name CGameState_World

func on_push(args: Array) -> void:
	GAPI.scenes_change(CEnums.EScenes.STREET);
	await StaticSignals.level_ready;
	GAPI.scenes_get_curren_level().spawn_player_at(GAPI.player, "");
	await GAPI.gui_get(CGUIList.EGUI.SCENE_TRANSITION).play_open();

func on_enter() -> void:
	StaticSignals.pickable_player_enter_pick_area.connect(_on_pickable_player_enter_pick_area);
	StaticSignals.storage_display_request.connect(_on_storage_display_request);
	StaticSignals.player_die.connect(_on_player_die);
	StaticSignals.player_enter_trigger_scene_change.connect(_on_player_enter_trigger_scene_change);
	StaticSignals.player_enter_trigger_door_unlock.connect(_on_player_enter_trigger_door_unlock);

func on_leave() -> void:
	StaticSignals.pickable_player_enter_pick_area.disconnect(_on_pickable_player_enter_pick_area);
	StaticSignals.storage_display_request.disconnect(_on_storage_display_request);
	StaticSignals.player_die.disconnect(_on_player_die);
	StaticSignals.player_enter_trigger_scene_change.disconnect(_on_player_enter_trigger_scene_change);
	StaticSignals.player_enter_trigger_door_unlock.disconnect(_on_player_enter_trigger_door_unlock);

func _on_player_die() -> void:
	GAPI.restart_game();

func _on_pickable_player_enter_pick_area(pickable: CPickable):
	if GAPI.get_player_inventory().is_full():
		return;
	
	if pickable.type == CItemType.EType.KEY:
		GAPI.player.keys += 1;
		StaticSignals.player_keys_changed.emit(GAPI.player.keys);
	else:
		GAPI.get_player_inventory().try_add_item(pickable.type);
	
	pickable.queue_free();

	StaticSignals.pickable_picked.emit(pickable);

func _on_storage_display_request(storage: CStorage):
	GAPI.GameState_Push(CEnums.EGameState.STORAGE, [storage]);

func _on_player_enter_trigger_scene_change(target_scene_name: String, target_player_spawn_position_id: String):
	if !GAPI.scenes_has(target_scene_name):
		push_error("Invalid scene name: ", target_scene_name);
		return;
	
	# Prevent re-enter to trigger
	GAPI.player.input_active = false;

	GlobalSounds.snd_door_enter.play();
	await GAPI.gui_get(CGUIList.EGUI.SCENE_TRANSITION).play_close();

	# Leave and save current level
	GAPI.player.set_collision_active(false);
	GAPI.player.get_parent().remove_child(GAPI.player);
	GAPI.scenes_save_current();

	# Load target level and spawn player at target position
	GAPI.scenes_change(target_scene_name);
	await StaticSignals.level_ready;
	GAPI.scenes_load();
	GAPI.player.set_collision_active(true);
	GAPI.player.reset_direction();
	GAPI.scenes_get_curren_level().spawn_player_at(GAPI.player, target_player_spawn_position_id);
	GAPI.player.input_active = true;

	await GAPI.gui_get(CGUIList.EGUI.SCENE_TRANSITION).play_open();

func _on_player_enter_trigger_door_unlock(door_lock: CDoorLock) -> void:
	GAPI.GameState_Push(CEnums.EGameState.DOOR_LOCK, [door_lock]);
