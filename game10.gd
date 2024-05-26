extends "res://Scripts/gamebase.gd"

var loops = 0
@export var bikeY = 775
@export var moving = true

func _ready():
	Engine.time_scale = Global.gameSpeed
	$Music.pitch_scale = Global.gameSpeed
	$Bike/Explosion.hide()
	$Warning.hide()
	moving = true
	if 9 not in Global.gamesBeat:
		$Hazard1.position.x += 100
	$Hazard1.position.x += Global.rng.randi_range(-200,500)
	
	if Global.difficulty < 1.75 or 9 not in Global.gamesBeat:
		$Hazard2.position.x += Global.rng.randi_range(-320,280)
		$Goblin.hide()
		$Goblin/Area2D/CollShape.disabled = true
	else:
		$Goblin.position.x += Global.rng.randi_range(-200,160)
		$Hazard1.position.x -= 500
		$Hazard2.hide()
		$Goblin/Run.play()
		$Hazard2/Area2D/CollShape.disabled = true
		await get_tree().create_timer(1.6,false).timeout
		$Warning.show()
		$Warn.play()
		$Warning/Shake.shake(18,false)
		$Goblin/Laugh.play()
		await get_tree().create_timer(0.2,false).timeout
		var tween = create_tween()
		tween.tween_property($Warning, "modulate", Color(1,1,1,0), 0.3)

func _input(_event):
	if Input.is_action_just_pressed("Click") and $Bike/AnimPlayer.current_animation != "jump":
		$Bike/AnimPlayer.play("jump")
		$Jump.play()

func _physics_process(delta):
	$Bike.position.y = bikeY
	if moving:
		$Hazard1.position.x -= (16 * (60 / (1/delta)))
		$Hazard2.position.x -= (16 * (60 / (1/delta)))
		$Goblin.position.x -= (30 * (60 / (1/delta)))
	else:
		$Bike.position.x += (22 * (60 / (1/delta)))

func on_loop_finished():
	if loops < 0:
		loops += 1
	else:
		$BG/AnimPlayer.play("end")
		await get_tree().create_timer(2.18,false).timeout
		$Grammy/AnimPlayer.play("idle")
		$GrammySFX.play()

func on_bike_area_entered(_area):
	complete = false
	$Bike/AnimPlayer.play("explode")
	$Explode.play()
	wrapUp.emit(0.22)
