extends Node2D

var arrowVel = Vector2(200,0)
@export var throwPos = 1250
var thrown = false
var landed = false
var hit = false
var picked = false
var damage = 85

signal dodamage(damage)

func _ready():
	$Bunch.hide()
	$Bunch.z_index = 1

func _process(delta):
	if not thrown:
		if $Bunch.position.x > 640:
			arrowVel.x -= 50
		else:
			arrowVel.x += 50
	elif not landed:
		$Bunch.position.y = throwPos
	$Bunch.position += arrowVel * delta
	
func _input(_event):
	if Input.is_action_just_pressed("Click") and not thrown and picked:
			thrown = true
			if $Bunch.position.x > 445 and $Bunch.position.x < 835:
				hit = true
			$Bunch/Arrow.hide()
			arrowVel = Vector2(0,0)
			$AnimPlayer.play("throw")
			$Bunch/Throw.play()

func on_pickup():
	$Prop.hide()
	$CL/Button.disabled = true
	$CL/Button.hide()
	$Bunch.show()
	await get_tree().create_timer(0.145,false).timeout
	picked = true

func on_anim_player_finished(anim_name):
	if anim_name == "throw":
		$Bunch.z_index = 0
		if hit == true:
			landed = true
			$Bunch/Part1.emitting = true
			$Bunch/Part2.emitting = true
			$Bunch.self_modulate = Color(1,1,1,0)
			$Bunch/Hit.play()
			dodamage.emit(damage)
		else:
			$AnimPlayer.play("fail")
			$Bunch/Miss.play()
			$Bunch.z_index = -2
			dodamage.emit(0)
		await get_tree().create_timer(2,false).timeout
		queue_free()
	elif anim_name == "intro" and not picked:
		$Prop/Land.play()

func delete():
	queue_free()
