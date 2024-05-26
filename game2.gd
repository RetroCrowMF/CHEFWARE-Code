extends "res://Scripts/gamebase.gd"

#@onready var swordColl = $Sword/Collision.shape
#var mouseSpeed = Vector2()
var lastMousePos = Vector2()
var sliced = 0
var quota = 5
@onready var fruit = preload("res://Scenes/fruit.tscn")
@onready var sword = $Sword

func _ready():
	quota += int(Global.difficulty / 1.5)
	if quota > 5:
		quota = 5
	$FruitsLeft.text = str(quota - sliced)
	$Music.pitch_scale = 0.5 + (Global.gameSpeed / 2)
	for i in (quota + 100):
		await get_tree().create_timer(Global.rng.randf_range(0.64,0.85),false).timeout
		fruitspawn()

func _process(_delta):
	lastMousePos = get_global_mouse_position()

func on_sword_area_entered(_area):
	sliced += 1
	if sliced >= quota:
		complete = true
		$FruitsLeft.text = "0"
		wrapUp.emit(2.2)
	else:
		$FruitsLeft.text = str(quota - sliced)

func fruitspawn():
	var fru = fruit.instantiate()
	add_child(fru)
	fru.global_position = Vector2(Global.rng.randf_range(1000,280),1080)
