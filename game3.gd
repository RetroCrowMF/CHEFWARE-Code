extends "res://Scripts/gamebase.gd"

var spoon = 1 # 1/2 TSP = 1     1 TBSP = 2     1 TSP = 3
var order = 1

signal setspoons(spoon, order)

func _ready():
	$Panel.hide()
	spoon = Global.rng.randi_range(1,3)
	if 2 not in Global.gamesBeat:
		$Arrow.show()
	if Global.difficulty < 2:
		order = Global.rng.randi_range(1,2)
		$Spoon3.hide()
		$Smoke.hide()
	else:
		order = Global.rng.randi_range(1,3)
		$Spoon3.show()
		$Smoke.show()
	setspoons.emit(spoon, order)
	if spoon == 1:
		$Text.text = "1/2 TSP"
	if spoon == 2:
		$Text.text = "1 TBSP"
	if spoon == 3:
		$Text.text = "1 TSP"
	$Smoke.modulate = Color(1,1,1,(Global.difficulty / 74))
	$Music.pitch_scale = Global.gameSpeed

func on_spoon_selected(mySpoon):
	$Panel.show()
	$Arrow/AnimPlayer.play("fade")
	if mySpoon == spoon:
		complete = true
		$AnimPlayer.play("Win")
		$Win.play()
		wrapUp.emit(1.5)
	else:
		$AnimPlayer.play("Lose")
		$Lose.play()
		wrapUp.emit(1.7)
		$Music.pitch_scale -= 0.5
		for i in 5000:
			$Hand/Shake.shake(1.2,false)
			await get_tree().create_timer(0.05,false).timeout
