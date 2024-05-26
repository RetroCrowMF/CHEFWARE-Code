extends Node2D

func leave():
	$AnimPlayer.play("exit")

func _process(_delta):
	position.x = get_global_mouse_position().x
	$Area2D.position.x = -((position.x - 640) / 8)

func shake():
	$Shake.shake(10,true)
