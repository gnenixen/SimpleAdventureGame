class_name CStorage

signal changed();

var _items: Array[CItemType.EType];
var _capacity: int = 10:
	set(value):
		_capacity = value;

		if _items.size() > _capacity:
			_items.resize(_capacity);

		changed.emit();

func try_add_item(item: CItemType.EType) -> bool:
	if is_full():
		return false;

	_items.append(item);

	changed.emit();
	
	return true;

func try_pop_item_from_cell(cell_id: int) -> CItemType.EType:
	if cell_id < 0 || cell_id >= _capacity || _items.size() < cell_id:
		push_error("Passed non valid cell_id: ", cell_id);
		return CItemType.EType.NONE;
	
	var item: CItemType.EType = _items[cell_id];

	_items.remove_at(cell_id);

	changed.emit();
	
	return item;

func get_item_in_cell(cell_id: int) -> CItemType.EType:
	if cell_id < 0 || cell_id >= _capacity || _items.size() - 1 < cell_id:
		return CItemType.EType.NONE;
	
	return _items[cell_id];


func is_full() -> bool:
	return _items.size() == _capacity;
