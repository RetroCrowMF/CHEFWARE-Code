extends "res://Scripts/gamebase.gd"

@onready var advert = preload("res://Scenes/ad.tscn")
@onready var winFlood = preload("res://Art/FloodEggplant1.png")
@onready var loseFlood = preload("res://Art/FloodEggplant2.png")
@onready var winErr = preload("res://Art/ErrorEggplant1.png")
@onready var loseErr = preload("res://Art/ErrorEggplant2.png")

var positions = [Vector2(84,116), Vector2(84,508), Vector2(642,116), Vector2(642,508)]

func _ready():
	$Panel.hide()
	$Error.hide()
	if Global.difficulty > 1.8 and 4 in Global.gamesBeat:
		adspawn()
		if Global.difficulty > 4.15:
			adspawn()
			if Global.difficulty > 8.2:
				adspawn()
	$Music.pitch_scale = Global.gameSpeed
	var selected = Global.rng.randi_range(0, (positions.size() - 1))
	$WrongButton1.position = positions[selected]
	positions.remove_at(selected)
	selected = Global.rng.randi_range(0, (positions.size() - 1))
	$WrongButton2.position = positions[selected]
	positions.remove_at(selected)
	selected = Global.rng.randi_range(0, (positions.size() - 1))
	$WrongButton3.position = positions[selected]
	positions.remove_at(selected)
	selected = Global.rng.randi_range(0, (positions.size() - 1))
	$RightButton.position = positions[selected]
	positions.remove_at(selected)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not $Click.playing:
			$Click.play()

func win():
	complete = true
	$Panel.show()
	$Error.texture = winErr
	$Flood.texture = winFlood
	$Error.show()
	$Click.play()
	$Beep.play()
	await get_tree().create_timer(0.5,false).timeout
	$AnimPlayer.play("Flood")
	$FloodSFX.play()
	wrapUp.emit(2)

func lose():
	$Panel.show()
	$Error.texture = loseErr
	$Flood.texture = loseFlood
	$Error.show()
	$Click.play()
	$Beep.play()
	await get_tree().create_timer(0.5,false).timeout
	$AnimPlayer.play("Flood")
	$FloodSFX.play()
	wrapUp.emit(2)

func adspawn():
	var ad = advert.instantiate()
	add_child(ad)
	ad.global_position = Vector2(Global.rng.randf_range(150,900),Global.rng.randf_range(245,845))
