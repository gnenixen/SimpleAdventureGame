class_name CFuncItem

class CAction:
	var label: String;
	var callable: Callable;
	var remove_after_action: bool = false;

var type: CItemType.EType;
var actions: Array[CAction];

var can_be_dropped: bool = true;

func register_actions() -> void:
	_register_actions();

	if can_be_dropped:
		add_action_with_remove_after_use("Drop", _drop_item);


func _register_actions() -> void:
	pass

func add_action(label: String, callable: Callable) -> void:
	var action: CAction = CAction.new();
	action.label = label;
	action.callable = callable;

	actions.append(action);

func add_action_with_remove_after_use(label: String, callable: Callable) -> void:
	var action: CAction = CAction.new();
	action.label = label;
	action.callable = callable;
	action.remove_after_action = true;

	actions.append(action);

func _drop_item() -> void:
	var pickable: CPickable = GAPI.scenes_get_curren_level().spawn_pickable(type, GAPI.player.global_position);
	pickable.ignore_player_first_enter = true;
	GlobalSounds.snd_drop_item.play();
