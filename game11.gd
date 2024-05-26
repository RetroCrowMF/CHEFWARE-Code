extends "res://Scripts/gamebase.gd"

@onready var egg = preload("res://Scenes/underegg.tscn")
var inBox = false

func _ready():
	$Panel.hide()
	if 10 in Global.gamesBeat:
		$Music.pitch_scale = (0.75 + (Global.gameSpeed / 4))
	else:
		await get_tree().create_timer(0.6,false).timeout
	await get_tree().create_timer(0.25,false).timeout
	for i in 9999:
		if complete:
			eggspawn()
		await get_tree().create_timer(Global.rng.randf_range(0.65,1),false).timeout
		$StayIn/Shake.shake(4.5,false)

func _physics_process(_delta):
	if inBox and complete:
		$Heart.global_position = get_global_mouse_position()

func on_box_entered():
	inBox = true
	$StayIn.hide()

func on_box_exited():
	inBox = false
	if complete:
		$StayIn.show()

func on_hurtbox_area_entered(_area):
	complete = false
	wrapUp.emit(2)
	$Die.play()
	$Heart/Hurtbox/CollShape.set_deferred("disabled",true)
	$Music.stop()
	$Heart.frame = 1
	$Panel.show()
	await get_tree().create_timer(1,false).timeout
	$Death.position = $Heart.position
	$Death.emitting = true
	$Heart.hide()

func eggspawn():
	var eg = egg.instantiate()
	add_child.call_deferred(eg)
	if not inBox:
		eg.global_position.y = $Heart.global_position.y
	else:
		eg.global_position.y = Global.rng.randf_range(470,775)
	var side = Global.rng.randi_range(1,2)
	if side == 1:
		eg.global_position.x = -75
	else:
		eg.global_position.x = 1355
		eg.direction = Vector2(-1,0)
