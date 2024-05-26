extends "res://Scripts/gamebase.gd"

var velocity = Vector2()
var lerpperc = 1.0
var newpos = Vector2()

var HP = 6

func _ready():
	HP += Global.difficulty
	if HP > 10:
		HP = 10
	$AnimPlayer.play("Idle")
	$Potato.position.x = Global.rng.randi_range(500,780)
	$Potato.position.y = Global.rng.randi_range(360,600)
	$Button.position = ($Potato.position - Vector2(188,134))
	$Potato/Sprite/Shake.offset = $Potato/Sprite.position
	$Music.pitch_scale = Global.gameSpeed

func _process(delta):
	if lerpperc < 1:
		lerpperc += delta * 0.7
		$Potato.position = $Potato.position.lerp(newpos,lerpperc)
		$Button.position = ($Potato.position - Vector2(188,134))

func on_potato_hit():
	HP -= 1
	if HP > 0:
		if get_global_mouse_position().x < $Potato.global_position.x:
			$Potato.scale = Vector2(-1,1)
		else:
			$Potato.scale = Vector2(1,1)
		$AnimPlayer.play("Hit")
		$Potato/Sprite/Punch.play()
		$Potato/Sprite/Shake.shake(13,false)
		if Settings.particles:
			$PotatoPart.position = get_global_mouse_position()
			$PotatoPart.restart()
		newpos = $Potato.position + Vector2(Global.rng.randi_range(-65,65),Global.rng.randi_range(-65,65))
		lerpperc = 0
	else:
		complete = true
		wrapUp.emit(1.8)
		$Button.disabled = true
		$AnimPlayer.play("Dead")
		$Potato/Sprite/Kill.play()
		$Potato/Sprite/Shake.shake(175,true)
		if Settings.particles:
			$PotatoPart.position = get_global_mouse_position()
			$PotatoPart2.position = get_global_mouse_position()
			$PotatoPart.restart()
			$PotatoPart2.emitting = true

func on_anim_player_finished(anim_name):
	if anim_name == "Hit":
		$AnimPlayer.play("Idle")
