extends Resource
class_name DialogueLine


#@export var name : String = "name"
@export_multiline var text : String = "I  am  speaking"
@export var speed_multiplier : float = 1.0
@export var text_sound : AudioStream = preload("res://SFX/Dialogue.ogg")
@export var text_sound_override : Dictionary = {" " : null, "\n" : null}
@export var animation = "idle"


#func GetName() -> String:
#	return name
func GetText() -> String:
	return text
func GetSpeedMultiplier() -> float:
	return speed_multiplier
func GetSound(c:String) -> AudioStream:
	if text_sound_override.has(c):
		if text_sound_override[c] is AudioStream or text_sound_override[c] == null:
			return text_sound_override[c]
	return text_sound
func GetState():
	return animation
