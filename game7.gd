extends "res://Scripts/gamebase.gd"

var beerVel = 0
var moved = false

func _ready():
	$Cowboy.frame = 1
	$Music.pitch_scale = 0.88 + (Global.gameSpeed / 10)
	if 6 not in Global.gamesBeat:
		$Arrow.show()
	else:
		$Arrow.hide()
	await get_tree().create_timer(Global.rng.randf_range(1.55,2.1),false).timeout
	beerVel = Global.rng.randi_range(19,22)
	beerVel += Global.difficulty / 2
	await get_tree().create_timer(1.65,false).timeout
	if not complete:
		$Rootbeer/Break.play()

func _process(delta):
	$Rootbeer.position.x -= (beerVel + delta) * Global.gameSpeed
	
	if Input.is_action_just_pressed("Click") and not moved and beerVel != 0:
		moved = true
		var generosity = 130
		$AnimPlayer.play("caught")
		$BG.position.x = 0
		if $Rootbeer.position.x < (206 + generosity) and $Rootbeer.position.x > (206 - generosity): #Perfect is 206
			complete = true
			$Rootbeer.hide()
			$Cowboy.frame = 0
			$Arrow/AnimPlayer.play("fade")
			$Rootbeer/Slide.stop()
			$Catch.play()
		else:
			if $Rootbeer.position.x > 206:
				$Label.text = "Too  Early!!"
			else:
				$Label.text = "Too  Late!!"
			$Label.show()
			$Label/Shake.shake(30,false)
			$Cowboy.frame = 2
			$Miss.play()
