extends Node
class_name CLevel

class CPickableSaveInfo:
	var position: Vector2;
	var type: CItemType.EType;

	func _init(pickable: CPickable) -> void:
		position = pickable.global_position;
		type = pickable.type;

class CDoorLockSaveInfo:
	pass

class CSaveData:
	var pickables: Array[CPickableSaveInfo];
	var door_locks: Array[bool];

@export var player_spawn_position: Marker2D;
@export var random_teleportation_navmesh: NavigationRegion2D;
@export var pickables_root_node: Node2D;

var _is_ready: bool = false;

func _ready() -> void:
	_is_ready = true;
	await get_tree().physics_frame;
	StaticSignals.level_ready.emit();

func get_save_data() -> CSaveData:
	var data: CSaveData = CSaveData.new();

	for i in pickables_root_node.get_children():
		data.pickables.append(CPickableSaveInfo.new(i));
	
	for i in get_tree().get_nodes_in_group(CEnums.EGroups.DOORS_LOCKS):
		if i is CDoorLock:
			data.door_locks.append(i.is_locked);
	
	return data;

func load_save_data(data: CSaveData) -> void:
	if !_is_ready:
		await StaticSignals.level_ready;
	
	# Clear all initially spawned pickables - anyway they saved to save data
	for i in pickables_root_node.get_children():
		i.queue_free();

	for i in data.pickables:
		spawn_pickable(i.type, i.position);
	
	var door_lock_id: int = 0;
	for i in get_tree().get_nodes_in_group(CEnums.EGroups.DOORS_LOCKS):
		if i is CDoorLock:
			i.set_collision_active(data.door_locks[door_lock_id]);
			door_lock_id += 1;

func spawn_pickable(type: CItemType.EType, pos: Vector2) -> CPickable:
	var item_def: CResourceItem = GAPI.items_db.get_resource_item_for_item_type(type);
	if !item_def:
		push_error("Invalid resource type: ", type);
		return null;

	var instance: CPickable = item_def.item_scene.instantiate();
	instance.position = pos;
	pickables_root_node.add_child(instance);

	return instance;

func spawn_player_at(player: CPlayer, target_spawn_position_id: String) -> void:
	var target_spawn_position: Vector2 = player_spawn_position.global_position;

	var player_spawn_positions: Array[Node] = get_tree().get_nodes_in_group(CEnums.EGroups.PLAYER_SPAWN_POSITIONS);
	for i in player_spawn_positions:
		if !(i is CPlayerSpawnPosition):
			continue;
		
		if i.spawn_position_name == target_spawn_position_id:
			target_spawn_position = i.global_position;
			break;

	player.position = target_spawn_position;
	add_child.call_deferred(player);
