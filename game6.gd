extends "res://Scripts/gamebase.gd"

var arrowVel = Vector2(200,0)
@export var throwPos = 0.0
var thrown = false
var landed = false

func _ready():
	$Music.pitch_scale = Global.gameSpeed
	if 5 not in Global.gamesBeat:
		$AnimPlayer.play("dumpGlow")

func _process(delta):
	if not thrown:
		if $Trash.position.x > 640:
			arrowVel.x -= ((20 + (Global.difficulty * 8)) * Engine.time_scale)
		else:
			arrowVel.x += ((20 + (Global.difficulty * 8)) * Engine.time_scale)
	elif not landed:
		$Trash.position.y = throwPos
	$Trash.position += arrowVel * delta

func _input(_event):
	if Input.is_action_just_pressed("Click") and not thrown:
		thrown = true
		if $Trash.position.x > 445 and $Trash.position.x < 835:
			complete = true
		$Trash/Arrow.hide()
		arrowVel = Vector2(0,0)
		$AnimPlayer.play("throw")
		$Trash/Throw.play()
	

func on_anim_player_finished(anim_name):
	if anim_name == "throw":
		if complete == true:
			landed = true
			if Settings.particles:
				$Trash/Part1.emitting = true
				$Trash/Part2.emitting = true
			$Dumpster/Shake.shake(8,false)
			$Trash.self_modulate = Color(1,1,1,0)
			$Trash/Hit.play()
			await get_tree().create_timer(0.4,false).timeout
			$AnimPlayer.play("rad")
			wrapUp.emit(1.2)
			await get_tree().create_timer(0.55,false).timeout
			for i in 1000:
				@warning_ignore("integer_division")
				$Rad/Shake.shake((i/5),false)
				await get_tree().create_timer(0.06,false).timeout
		else:
			$AnimPlayer.play("miss")
			$Trash.z_index = 0
			$Trash/Miss.play()
			$Music.stop()
