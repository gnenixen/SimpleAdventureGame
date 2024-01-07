extends CharacterBody2D
class_name CPlayer

@export var hp: int = 10:
	set(value):
		var old_hp = hp;

		hp = clamp(value, 0, max_hp);

		StaticSignals.player_hp_changed.emit(old_hp, max_hp, hp, max_hp);

		if hp == 0:
			StaticSignals.player_die.emit();

@export var max_hp: int = 10:
	set(value):
		var old_hp = hp;
		var old_max_hp = max_hp;

		max_hp = value;
		hp = clamp(hp, 0, max_hp);

		StaticSignals.player_hp_changed.emit(old_hp, old_max_hp, hp, max_hp);

@export var interactable_object_raycast: RayCast2D;

@export var visual_sprite: Sprite2D;

@export var visual_texture_front: Texture;
@export var visual_texture_back: Texture;
@export var visual_texture_side: Texture;

var keys: int = 0:
	set(value):
		keys = value;
		if keys < 0:
			keys = 0;
		
		StaticSignals.player_keys_changed.emit(keys);

var inventory: CStorage = CStorage.new();

var input_active: bool = true;

# Initialy player looks in up direction
var _last_strong_move_direction: Vector2 = Vector2(0, -1);

# Cache length of interactable object raycast for correct rotation logic in future
var _interactable_object_raycast_length: float;

var _initial_collision_layer: int;
var _initial_collision_mask: int;

# Visual sprite offset power for simple move animation
var _offset_power: float = 0.0;
var _last_cos_period: int = 0;

var _cv_player_movespeed_base := CCVarsList.cv_player_movespeed_base.GetInternal();

func _init() -> void:
	_initial_collision_layer = collision_layer;
	_initial_collision_mask = collision_mask;

func _ready() -> void:
	# Initial sinchronization for UI
	StaticSignals.player_hp_changed.emit(hp, max_hp);
	StaticSignals.player_keys_changed.emit(keys);

	_interactable_object_raycast_length = interactable_object_raycast.target_position.length();

func _process(delta: float) -> void:
	# Simple animation for player

	# Check is player even moving
	var moving: bool = velocity.length() > 0.0;

	# Convert moving to range -1 for false and 1 for true; (false, true) -> (-1, 0)
	var moving_val: int = (moving as int) * 2 - 1;

	# Make a little power curve at start and finish
	_offset_power = clamp(_offset_power + delta * 3.5 * moving_val, 0.0, 1.0);

	var cos_time: float = Time.get_ticks_msec() * 0.02;

	# Some beauty for cos and convert to range (0; 1)
	var cos_val = (cos(cos_time) + 1.0) * 0.5;

	# Just offset visual sprite with max height
	visual_sprite.offset.y = -(cos_val * _offset_power) * 300.0;

	# Play a simple jump sound
	var cos_period: int = (cos_time / PI * 0.5) as int;

	if _last_cos_period != cos_period && moving:
		GlobalSounds.snd_jump.volume_db = -60 * (1.0 - _offset_power) - 10.0;
		GlobalSounds.snd_jump.play();
		_last_cos_period = cos_period;


func _physics_process(delta: float) -> void:
	if !input_active:
		return;

	var direction: Vector2 = CInputHelper.get_move_input_normalized();

	_process_move(direction, delta);
	_update_interactable_object_raycast();
	_update_visual_sprite();

func _input(event: InputEvent) -> void:
	if !input_active:
		return;

	if event.is_action_pressed("interact"):
		_try_interact();
		return;

func reset_direction() -> void:
	_last_strong_move_direction = Vector2.UP;

func set_collision_active(value: bool) -> void:
	if value:
		collision_layer = _initial_collision_layer;
		collision_mask = _initial_collision_mask;
	else:
		collision_layer = 0;
		collision_mask = 0;

func _process_move(direction: Vector2, _delta: float) -> void:
	if direction.length() > 0:
		_last_strong_move_direction = direction;
	
	velocity = direction * _cv_player_movespeed_base.mValue;
	
	move_and_slide();

func _update_interactable_object_raycast() -> void:
	interactable_object_raycast.target_position = _last_strong_move_direction * _interactable_object_raycast_length;

func _update_visual_sprite() -> void:
	var target_texture: Texture;
	if _last_strong_move_direction == Vector2.UP:
		target_texture = visual_texture_back;
	elif _last_strong_move_direction == Vector2.DOWN:
		target_texture = visual_texture_front;
	else:
		target_texture = visual_texture_side;
	
	if visual_sprite.texture != target_texture:
		visual_sprite.texture = target_texture;
	
	if _last_strong_move_direction.y == 0.0:
		visual_sprite.flip_h = _last_strong_move_direction == Vector2.RIGHT;
	else:
		visual_sprite.flip_h = false;

func _try_interact() -> void:
	var interactable_object: CInteractableObject = _try_get_target_interactable_object();
	if !interactable_object:
		return;

	var direction_to_interactable_object: Vector2 = global_position.direction_to(interactable_object.global_position);
	var dot: float = direction_to_interactable_object.dot(_last_strong_move_direction);
	if dot >= 0.5:
		interactable_object.interact();

func _try_get_target_interactable_object() -> CInteractableObject:
	return interactable_object_raycast.get_collider() as CInteractableObject;
