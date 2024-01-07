extends Node
class_name CGAPI

var mSceneManager: CSceneManager = CSceneManager.new();
var mGameStatesManager: CGameStatesManager = CGameStatesManager.new();
var mGUIManager: CGUIManager = CGUIManager.new();

var player: CPlayer;
var items_db: CItemsDB = null;
var scene_name_to_save: Dictionary;

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS;

	mGUIManager.Initialize();

	items_db = load("res://items_db.tres");
	items_db.initialize_item_type_to_func_item();

	scenes_register(CEnums.EScenes.STREET, "res://assets/scenes/scn_street.tscn");
	scenes_register(CEnums.EScenes.HOUSE_1, "res://assets/scenes/scn_house_1.tscn");
	scenes_register(CEnums.EScenes.HOUSE_2, "res://assets/scenes/scn_house_2.tscn");
	scenes_register(CEnums.EScenes.HOUSE_3, "res://assets/scenes/scn_house_3.tscn");

	gui_register(CGUIList.EGUI.MAIN, preload("res://assets/gui/gui_main.tscn"));
	gui_register(CGUIList.EGUI.STORAGE, preload("res://assets/gui/gui_storage.tscn"));
	gui_register(CGUIList.EGUI.DOOR_LOCK, preload("res://assets/gui/gui_door_lock.tscn"));
	gui_register(CGUIList.EGUI.SCENE_TRANSITION, preload("res://assets/gui/gui_scene_transition_effect.tscn"));

	GameState_RegisterState(CEnums.EGameState.GAME, CGameState_World.new());
	GameState_RegisterState(CEnums.EGameState.STORAGE, CGameState_Storage.new());
	GameState_RegisterState(CEnums.EGameState.DOOR_LOCK, CGameState_DoorLock.new());

	restart_game();

func get_player_inventory() -> CStorage:
	return player.inventory;

func reset_player_and_scenes_saves() -> void:
	if player:
		player.queue_free();

	player = load("res://assets/entities/ent_player.tscn").instantiate();

	scene_name_to_save.clear();

func restart_game() -> void:
	_restart_game.call_deferred();

func _restart_game() -> void:
	while GameState_GetStackSize() != 0:
		GameState_Pop();
	
	reset_player_and_scenes_saves();
	GameState_Push(CEnums.EGameState.GAME);


#region GUI

func gui_register(guiName: String, gui) -> void:
	mGUIManager.Register(guiName, gui);

func gui_get(guiName: String) -> CGUIObject:
	return mGUIManager.Get(guiName);

func GUI_Has(guiName: String) -> bool:
	return mGUIManager.Has(guiName);

#endregion

#region Scene 

func scenes_register(
	sceneName: String,
	sceneFilePath: String
) -> void:
	mSceneManager.Register(sceneName, sceneFilePath);

func scenes_change(to: String) -> void:
	mSceneManager.TransitionTo(to);

func scenes_has(_name: String) -> bool:
	return mSceneManager.Has(_name);

func scenes_save_current() -> void:
	scene_name_to_save[mSceneManager.mCurrentScene] = scenes_get_curren_level().get_save_data();

func scenes_load() -> void:
	if scene_name_to_save.has(mSceneManager.mCurrentScene):
		scenes_get_curren_level().load_save_data(scene_name_to_save[mSceneManager.mCurrentScene]);

func scenes_get_curren_level() -> CLevel:
	return get_tree().current_scene as CLevel;

#endregion

#region Game States

"""
Game states have simple logic - you can push and pop registered states. Thats all you really need.
"""

func GameState_RegisterState(
	state : int,
	stateOperator : IGameState
) -> void:
	mGameStatesManager.RegisterState(state, stateOperator);

func GameState_Push(id: int, args: Array = []) -> void:
	mGameStatesManager.Push(id, args);

func GameState_SafePush(id : int, args : Array = []) -> void:
	if !GameState_IsInState(id):
		mGameStatesManager.Push(id, args);

func GameState_Pop() -> void:
	mGameStatesManager.Pop();

func GameState_SafePop(expectedId: int) -> void:
	if GameState_IsInState(expectedId):
		mGameStatesManager.Pop();

func GameState_GetCurrentStateId() -> int:
	return mGameStatesManager.GetCurrentStateId();

func GameState_IsInState(id: int) -> bool:
	return GameState_GetCurrentStateId() == id;

func GameState_OverwriteStackTop(to: int) -> void:
	mGameStatesManager.OverrideStackTop(to);

func GameState_GetStackSize() -> int:
	return mGameStatesManager.GetStackSize();

#endregion

#region Utils

func NewHandlerNode(nameForNode: String, type):
	var node = type.new();
	node.name = nameForNode;
	add_child(node);

	return node;

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("show_inventory"):
		StaticSignals.storage_display_request.emit(player.inventory);
		return;

#endregion
