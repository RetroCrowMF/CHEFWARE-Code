extends Node2D

var velocity = Vector2()

func _ready():
	velocity = Vector2(Global.rng.randf_range(100,-100),-1600)


func _process(delta):
	global_position += velocity * delta
	velocity.y += 3400 * delta
	$ShapeCast.target_position = velocity * delta
	#await get_tree().process_frame
	if $ShapeCast.is_colliding():
		jump()

func jump():
	if velocity.y > 0:
		position = $ShapeCast.get_collision_point(0)
		velocity = Vector2(Global.rng.randf_range(600,-600),-1755)
		$Fizz.play()

func on_area_2d_entered(area):
	if area.get_collision_layer_value(3) == true:
		if position.x > 640:
			position.x = 1210
		else:
			position.x = 71
		velocity.x *= -1
	elif area.get_collision_layer_value(4) == true:
		$Area2D/CollShape.set_deferred("disabled",true)
	else:
		jump()
