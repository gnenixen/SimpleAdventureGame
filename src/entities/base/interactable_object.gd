extends StaticBody2D
class_name CInteractableObject

@export var display_message: String = "";

func interact() -> void:
    GlobalSounds.snd_interact.play();
    StaticSignals.interactable_interact_request.emit(display_message);