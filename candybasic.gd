extends Node2D

func on_mouse_entered():
	Global.candies += 1
	$Area2D/CollShape.disabled = true
	$Collect.play()
	hide()

func on_sfx_finished():
	queue_free()
