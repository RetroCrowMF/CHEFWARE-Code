extends "res://Scripts/gamebase.gd"

func _ready():
	if Settings.particles:
		$Embers.emitting = true
	$Music.pitch_scale = (0.5 + (Global.gameSpeed / 2))
	$Pan.scale.x = 1 - (Global.difficulty / 20)
	if $Pan.scale.x < 0.6:
		$Pan.scale.x = 0.6

func _process(_delta):
	$Pan.global_position.x = get_global_mouse_position().x

func on_lose_area_entered(_area):
	complete = false
	wrapUp.emit(1.25)
	$Music.stop()
	$LoseSFX.play()
