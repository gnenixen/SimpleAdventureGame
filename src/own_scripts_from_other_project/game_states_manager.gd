class_name CGameStatesManager

var mCurrent : int = CEnums.EGameState.NONE;

var mStates : Dictionary = {};
var mStack : Array[int] = [];

func RegisterState(state : int, stateOperator : IGameState):
	mStates[state] = stateOperator;

func OverrideStackTop(to : int, args : Array = []) -> void:
	assert(mStates.has(to), "Not found state with given id");

	if mStack.is_empty():
		Push(to, args);
		return;
	
	# We are already at the same state, do nothing
	if mStack[-1] == to:
		return;
	
	Pop();
	Push(to, args);

func Push(id : int, args : Array = []) -> void:
	assert(mStates.has(id), "Not found state with given id");
	assert(!mStack.has(id), "Same state already at game states stack");
	assert(GetCurrentState() != mStates[id], "Given state id already at the top of stack");

	if !mStack.is_empty():
		await GetCurrentState().on_leave();

	mStack.append(id);

	await GetCurrentState().on_push(args);
	await GetCurrentState().on_enter();

func Pop() -> void:
	assert(!mStack.is_empty(), "Game states stack already empty");

	var state = GetCurrentState();

	mStack.remove_at(mStack.size() - 1);

	await state.on_pop();

	if !mStack.is_empty():
		await GetCurrentState().on_enter();

func GetCurrentStateId() -> int:
	if mStack.is_empty():
		return -1;

	return mStack[-1];

func GetCurrentState() -> IGameState:
	if !mStack.size():
		return null;

	return mStates[mStack[-1]];

func GetStackSize() -> int:
	return mStack.size();

func _process(delta : float) -> void:
	var state = GetCurrentState();
	if !state:
		return;
	
	state._process(delta);
