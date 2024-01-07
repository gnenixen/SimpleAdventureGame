class_name CSceneManager

var mScenesFilesPaths: Dictionary = {};

var mCurrentScene: String;

func Register(sceneName: String, sceneFilePath: String):
	if !FileAccess.file_exists(sceneFilePath):
		return;

	mScenesFilesPaths[sceneName] = sceneFilePath;

func Has(name: String):
	return mScenesFilesPaths.has(name);

func TransitionTo(name: String):
	if !mScenesFilesPaths.has(name):
		return;

	GAPI.get_tree().change_scene_to_file(mScenesFilesPaths[name]);
	mCurrentScene = name;

func IsCurrent(name: String) -> bool:
	return mCurrentScene == name;