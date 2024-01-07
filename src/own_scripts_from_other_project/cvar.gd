"""
CVars is very usefull, but there one moment you need to understand.
Instead of doing something like that:
	var sensivity = rawMouseMove * GCVars.mMouseSensivity.Get();

Do this:
	# Add this at class members definition
	var mMouseSensivity := GCVars.mMouseSensivity.GetInternal();

	# And use later
	var sensivity = rawMouseMove * mMouseSensivity.mValue;

This is because first code is much slower than second, since GCVars for
reason in reality is get_node(\"GCVars\"), that is not really fast.

Cahcing is a thing my dudes.
"""
class_name CVar

# This class exists only for correct referencing
class CCvarInternal:
	signal OnValueChanged(newValue : Variant);

	var mName: StringName = &"";
	var mValue: Variant = null:
		set(value):
			mValue = value;

			if mInitialValue == null:
				mInitialValue = value;

			OnValueChanged.emit(value);
		get:
			return mValue;
	
	var mInitialValue: Variant = null;

	func ResetValueToInitialState():
		mValue = mInitialValue;

static var mCVarsList: Dictionary = {}

var mInternal: CCvarInternal = null;

func _init(name: StringName, value: Variant = null):
	if mCVarsList.has(name):
		mInternal = mCVarsList[name];
		# Do not override internal value
		return;
	
	mInternal = CCvarInternal.new();
	mInternal.mName = name;
	mInternal.mValue = value;

	mCVarsList[name] = mInternal;

func Get() -> Variant:
	assert(mInternal);

	return mInternal.mValue;

func Set(value : Variant) -> void:
	assert(mInternal);

	mInternal.mValue = value;

func GetInternal() -> CCvarInternal:
	return mInternal;

func _to_string():
	if !mInternal:
		return "INVALID_CVAR";

	return str(mInternal.mValue);

func OnValueChanged(to: Callable) -> CVar:
	assert(GetInternal());

	GetInternal().OnValueChanged.connect(to);

	return self;

static func ConnectValueChanged(cvar: CVar, to: Callable) -> void:
	assert(cvar);

	cvar.GetInternal().OnValueChanged.connect(to);

static func FindCVar(name: StringName) -> CCvarInternal:
	for cvar in mCVarsList:
		if cvar == name:
			return mCVarsList[cvar];
	
	return null;
