extends Resource
class_name CItemsDB

@export var items: Array[CResourceItem];

var _item_type_to_func_item: Dictionary;

func initialize_item_type_to_func_item() -> void:
    for i in items:
        if i.func_script_file != "":
            var instance = load(i.func_script_file).new();
            instance.type = i.type;
            instance.register_actions();
            _item_type_to_func_item[i.type] = instance;

func get_resource_item_for_item_type(type: CItemType.EType) -> CResourceItem:
    for i in items:
        if i.type == type:
            return i;
    
    return null;

func get_func_item_for_item_type(type: CItemType.EType) -> CFuncItem:
    return _item_type_to_func_item.get(type);
