extends CGUIObject
class_name CGUIStorage

@export var guicmp_storage_item_packed_scene: PackedScene;

@export var items_grid: GridContainer;
@export var item_name: Label;
@export var item_description: RichTextLabel;
@export var item_actions_containter: VBoxContainer;

var _items_in_grid: Array;
var _current_storage: CStorage:
	set(value):
		if _current_storage == value:
			return;

		if _current_storage:
			_current_storage.changed.disconnect(_on_current_storage_state_changed);
		
		_current_storage = value;

		if _current_storage:
			_current_storage.changed.connect(_on_current_storage_state_changed);

func _ready() -> void:
	visible = false;

func display_storage(storage: CStorage) -> void:
	_current_storage = storage;

	_clear_display_item_info();

	# Change number of items in grid view to be the same as capacity of storage
	if _items_in_grid.size() < storage._capacity:
		for i in range(0, storage._capacity - _items_in_grid.size()):
			_add_new_item_to_grid();
	elif _items_in_grid.size() > storage._capacity:
		for i in range(0, _items_in_grid.size() - storage._capacity):
			_remove_last_item_from_grid();
	
	# Load all items icons
	for i in range(0, storage._capacity):
		var item: CItemType.EType = storage.get_item_in_cell(i);
		var item_def: CResourceItem = GAPI.items_db.get_resource_item_for_item_type(item);
		if item_def:
			_items_in_grid[i].item_type = item;
			_items_in_grid[i].set_icon(item_def.icon);
		else:
			_items_in_grid[i].item_type = CItemType.EType.NONE;
			_items_in_grid[i].set_icon(null);

	# Grab focus to first item in grid
	if _items_in_grid.size() > 0:
		_items_in_grid[0].grab_focus();
	
func _on_current_storage_state_changed() -> void:
	display_storage(_current_storage);

func _add_new_item_to_grid() -> void:
	var item: CGUICmpStorageItem = guicmp_storage_item_packed_scene.instantiate();

	item.focus_entered.connect(_on_item_focus_enter.bind(_items_in_grid.size()));

	items_grid.add_child(item);
	_items_in_grid.append(item);

func _remove_last_item_from_grid() -> void:
	_items_in_grid[_items_in_grid.size() - 1].queue_free();
	_items_in_grid.remove_at(_items_in_grid.size() - 1);

func _on_item_focus_enter(item_cell: int) -> void:
	_clear_display_item_info();

	var item: CGUICmpStorageItem = _items_in_grid[item_cell];

	# Load all needed information for item type
	var res_item: CResourceItem = GAPI.items_db.get_resource_item_for_item_type(item.item_type);

	if !res_item:
		push_error("Invalid item type: ", item.item_type);
		return;
	
	item_name.text = res_item.name;
	item_description.text = res_item.description;
	
	var func_item: CFuncItem = GAPI.items_db.get_func_item_for_item_type(item.item_type);
	if func_item:
		for i in func_item.actions:
			var button: Button = Button.new();
			button.text = i.label;
			button.pressed.connect(i.callable);

			if i.remove_after_action:
				button.pressed.connect(func(): _current_storage.try_pop_item_from_cell(item_cell));

			item_actions_containter.add_child(button);

func _clear_display_item_info() -> void:
	for i in item_actions_containter.get_children():
		i.queue_free();

	item_name.text = "";
	item_description.text = "";
