extends Node2D

var speed = 600
var direction = Vector2(1,0)

func _ready():
	speed += int(Global.difficulty * 7)
	speed += Global.rng.randi_range(-80,80)
	if direction.x == -1:
		$Sprite2D.flip_h = true
		$Sprite2D.offset.x = 5
	await get_tree().create_timer(4,false).timeout
	queue_free()

func _physics_process(delta):
	global_position += speed * direction * delta
