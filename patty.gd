extends Node2D

var heat = 10
var rng = RandomNumberGenerator.new()
var wasted = false

signal lost(pos)

func _ready():
	$Sprite2D.frame = 0
	heat += rng.randi_range(-3,5)
	cook()

func cook():
	if not wasted:
		heat += 1
		if heat >= 40 and $AnimPlayer.current_animation != "take":
			wasted = true
			lost.emit(global_position)
			$Button.disabled = true
			$AnimPlayer.play("die")
			$Fizz.play()
		elif heat == 30:
			$Shake.shake(6,false)
			$AnimPlayer.play("cooked")
			$Fizz.play()
		elif heat == 20:
			$Shake.shake(2,false)
			$Sprite2D.frame = 1
		await get_tree().create_timer(rng.randf_range(0.15,0.25),false).timeout
		cook()

func on_button_pressed():
	$Shake.shake(2,false)
	if heat < 40:
		if heat >= 30:
			$Button.disabled = true
			$AnimPlayer.play("take")
			$Take.play()
			await get_tree().create_timer(0.23,false).timeout
			queue_free()
		else:
			$AnimPlayer.play("wait")

func on_anim_finished(anim_name):
	if anim_name == "wait":
		if heat >= 20 and heat <= 30:
			$Shake.shake(2,false)
			$Sprite2D.frame = 1
		elif heat < 20:
			$Sprite2D.frame = 0
