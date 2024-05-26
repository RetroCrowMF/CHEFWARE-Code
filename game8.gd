extends "res://Scripts/gamebase.gd"

var shreds = 0
var quota = 36
var goalright = false

func _ready():
	quota -= int(Global.difficulty * 2)
	$Music.pitch_scale = (0.75 + (Global.gameSpeed / 4))
	$Prop1.position.x = Global.rng.randf_range(200,240)
	$Prop2.position.x = Global.rng.randf_range(1055,1085)

func _process(_delta):
	$Grater.global_position.x = get_global_mouse_position().x
	$Cheese.global_position.x = (get_global_mouse_position().x * -1) + 1280

func shred(_area):
	shreds += 1
	if shreds == quota:
		win()
	elif shreds > quota:
		complete = true
	else:
		$Grater/Shred.play()
		$Cheese.scale.y = 1 - float(shreds) / float(quota + 1)
		var lastshreds = shreds
		if Settings.particles:
			$Grater/Shreddings.emitting = true
			$Grater/Shreddings2.emitting = true
			await get_tree().create_timer(0.25,false).timeout
			if lastshreds == shreds:
				$Grater/Shreddings.emitting = false
				$Grater/Shreddings2.emitting = false

func win():
	complete = true
	$Cheese.hide()
	$Grater/Shreddings.emitting = false
	$Grater/Shreddings2.emitting = false
	var tween = create_tween()
	tween.tween_property($Camera2D, "position", Vector2(640,920), 1.1).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	wrapUp.emit(1)
