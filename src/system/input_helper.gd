class_name CInputHelper

static func get_move_input_raw() -> Vector2:
	var direction: Vector2 = Vector2.ZERO;

	if Input.is_action_pressed("ui_left"):
		direction.x = -1;
	elif Input.is_action_pressed("ui_right"):
		direction.x = 1;
	else:
		direction.x = 0;

	if Input.is_action_pressed("ui_up"):
		direction.y = -1;
	elif Input.is_action_pressed("ui_down"):
		direction.y = 1;
	else:
		direction.y = 0;
	
	# Since we use JRPG style movement we disable diagonal movement
	if direction.y != 0:
		direction.x = 0;
	
	return direction;

static func get_move_input_normalized() -> Vector2:
	return get_move_input_raw().normalized();