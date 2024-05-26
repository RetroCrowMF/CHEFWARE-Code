extends Node2D

@onready var swordColl = $Hitbox/Collision.shape
var mouseSpeed = Vector2()
var lastMousePos = Vector2()

func _ready():
	get_parent().sword = self
	if Global.bossfight:
		await get_tree().create_timer(4,false).timeout
		$Trail.hide()
		await get_tree().create_timer(0.3,false).timeout
		queue_free()

func _process(_delta):
	$Hitbox.position = get_global_mouse_position() - ((get_global_mouse_position() - lastMousePos) / 1.6)
	swordColl.size.x = ((get_global_mouse_position() - lastMousePos).length()) * 1.4
	$Hitbox.rotation = get_global_mouse_position().angle_to_point(lastMousePos)
	
	if (lastMousePos - get_global_mouse_position()).length() > 40:
		$Hitbox/Collision.disabled = false
		$Trail.show()
	else:
		$Hitbox/Collision.disabled = true
		$Trail.hide()
	
	lastMousePos = get_global_mouse_position()
