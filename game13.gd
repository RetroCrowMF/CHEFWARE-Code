extends "res://Scripts/gamebase.gd"

var burg = 0
var side = 0
var customer = 0

func _ready():
	$Music.pitch_scale = (0.75 + (Global.gameSpeed / 4))
	burg = Global.rng.randi_range(1,3)
	side = Global.rng.randi_range(1,3)
	Global.order = [burg,side]
	$Burg.frame = (burg - 1)
	$Side.frame = (side + 2)
	customer = Global.rng.randi_range(1,2)
	if customer == 1:
		$Customer/AnimPlayer.play("cust1")
	else:
		$Talk.pitch_scale = 1.75
		$Customer/AnimPlayer.play("cust2")
	await get_tree().create_timer(time - 0.05,false).timeout
	$Notepad.save_art()

func note_taken():
	complete = true
