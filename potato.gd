extends Node2D

var HP = 10

signal death()

func _ready():
	$CL/Button.disabled = true
	while HP > 0:
		await get_tree().create_timer(4,false).timeout
		if HP > 0:
			$CL/Button.disabled = true
			$AnimPlayer.play("punch")
			get_parent().playerhurt(Vector2(748,830),Color(1,1,0.82,1))

func on_button_pressed():
	if $AnimPlayer.current_animation != "punch":
		$AnimPlayer.play("hit")
		$Punch.play()
		HP -= 1
		if Settings.particles:
			$PotatoPart.position = get_global_mouse_position() - position
			$PotatoPart.restart()
		if HP < 1:
			die()

func die():
	HP = 0
	$CL/Button.disabled = true
	$Sprite2D.hide()
	$AnimPlayer.play("death")
	$PotatoPart2.emitting = true
	$Kill.play()
	death.emit()

func on_anim_player_finished(anim_name):
	if anim_name == "intro" or anim_name == "hit" or anim_name == "punch":
		$CL/Button.disabled = false
		$AnimPlayer.play("idle")
	elif anim_name == "death":
		await get_tree().create_timer(3,false).timeout
		queue_free()
