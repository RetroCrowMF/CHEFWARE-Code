extends "res://Scripts/gamebase.gd"

var killPatty = 0
var pattyNo = 5

func _ready():
	$Panel.hide()
	$Music.pitch_scale = (0.75 + (Global.gameSpeed / 4))
	if 11 not in Global.gamesBeat:
		pattyNo -= 1
	pattyNo += int((Global.difficulty/1.5) - 1)
	if pattyNo > 7:
		pattyNo = 7
	for i in (8 - pattyNo):
		killPatty = Global.rng.randi_range(1,($Patties.get_child_count() - 1))
		$Patties.get_child(killPatty).queue_free()
		await get_tree().process_frame
	killPatty = Global.rng.randi_range(1,($Patties.get_child_count() - 1))
	$Patties.get_child(killPatty).heat += 5

func lose(pos):
	complete = false
	$Music.stop()
	$Panel.show()
	$LightSFX.play()
	for i in $Patties.get_child_count():
		$Patties.get_child(i).heat = -5000
	$Spotlight.show()
	$Spotlight.position = pos
