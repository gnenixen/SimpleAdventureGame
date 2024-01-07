class_name IGameState

# Called when state pushed to stack
func on_push(args: Array) -> void: pass
# Called when enter to state after pop of prev state
func on_enter() -> void: pass
# Called when other state pushed to stack
func on_leave() -> void: pass
# Called when state popped from stack
func on_pop() -> void: pass

func _process(delta : float) -> void: pass