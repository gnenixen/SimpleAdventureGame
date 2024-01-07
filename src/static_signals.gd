extends Node
class_name CStaticSignals

"""
GDScript does not allow you to create static signals, so we will keep such things in a singleton
"""

signal storage_display_request(storage: CStorage);

#region Level

signal level_ready();

#endregion

#region Player

signal player_die();
signal player_hp_changed(old_hp: int, old_max_hp: int, new_hp: int, new_max_hp: int);
signal player_keys_changed(new_keys: int);
signal player_enter_trigger_scene_change(target_scene_name: String, target_player_spawn_position_id: String);
signal player_enter_trigger_door_unlock(door_lock: CDoorLock);

#endregion

#region Interactable Objects

signal interactable_interact_request(message: String);

#endregion

#region Pickables

signal pickable_player_enter_pick_area(pickable: CPickable);
signal pickable_picked(pickable: CPickable);

#endregion