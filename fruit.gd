extends Node2D

var fruit = 1
var velocity = Vector2()
@onready var melon = preload("res://Art/FruitMelon.png")
@onready var orange = preload("res://Art/FruitOrange.png")
var sliced = false
var gravity = 1200
var onScreen = true

func _ready():
	if not Global.bossfight:
		velocity = Vector2(Global.rng.randf_range(-300,300),Global.rng.randf_range(-1450,-1000))
	else:
		velocity = Vector2(Global.rng.randf_range(-200,200),Global.rng.randf_range(-1350,-980))
		$MelonPart.lifetime = 0.7
		$OrangePart.lifetime = 0.7
	fruit = Global.rng.randi_range(1,2)
	if fruit == 1:
		$Sprite2D.texture = melon
		$Area2D/CollisionShape2D.scale = Vector2(1.2,1)
		scale -= Vector2(0.1,0.1)
	else:
		$Sprite2D.texture = orange
		$Area2D/CollisionShape2D.scale = Vector2(0.5,0.5)
		scale += Vector2(0.25,0.25)
	$OrangePart.process_material = $OrangePart.process_material.duplicate()
	$MelonPart.process_material = $MelonPart.process_material.duplicate()
	if Global.bossfight:
		z_index -= 1
		scale -= Vector2(0.45,0.45)
		gravity -= 225
		await get_tree().create_timer(1.1,false).timeout
		if not sliced:
			top_level = true
			z_index += 2
		await get_tree().create_timer(1.1 + (velocity.y / -1000),false).timeout
		if not sliced and onScreen:
			if fruit == 1:
				get_parent().playerhurt(position,Color(1,0.66,0.77,1))
			else:
				get_parent().playerhurt(position,Color(1,0.72,0.51,1))
			$PlayerHit.play()
			slice(Vector2(0,0))

func _process(delta):
	if not sliced:
		global_position += velocity * delta
		velocity.y += gravity * delta
	if Global.bossfight:
		scale += Vector2(0.3 * delta,0.3 * delta)
		

func on_area_2d_entered(_area):
	$Slice.play()
	var dir = (get_global_mouse_position() - get_parent().sword.lastMousePos).normalized()
	slice(dir)

func slice(dir):
	sliced = true
	var particle:GPUParticles2D
	if fruit == 1:
		$MelonPart.emitting = true
		particle = $MelonPart
	else:
		$OrangePart.emitting = true
		particle = $OrangePart
	$Area2D/CollisionShape2D.set_deferred("disabled",true)
	var pm = particle.process_material as ParticleProcessMaterial
	pm.direction = Vector3(dir.x,dir.y,0.0)
	pm.scale_min = scale.x
	$Sprite2D.hide()
	await get_tree().create_timer(3,false).timeout
	queue_free()

func on_screen_exited():
	onScreen = false
