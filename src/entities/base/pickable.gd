extends Node2D
class_name CPickable

@export var type: CItemType.EType

# True for objest dropped by the player, just to prevent moments when dropped object immediatly back to inventory
var ignore_player_first_enter: bool = false;

func _on_area_2d_body_entered(body: Node2D):
	if body is CPlayer:
		if ignore_player_first_enter:
			ignore_player_first_enter = false;
			return;
		
		StaticSignals.pickable_player_enter_pick_area.emit(self);
