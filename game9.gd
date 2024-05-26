extends "res://Scripts/gamebase.gd"

var generosity = 31

func _ready():
	$Music.seek((127 + Global.rng.randf_range(-3,5)))
	$Music.pitch_scale = (0.75 + (Global.gameSpeed / 4))
	if 8 not in Global.gamesBeat:
		$Handle/AnimPlayer.play("flash")
	$Beer.position.y = 1195
	$Line.position.y = Global.rng.randi_range(452,734)
	await get_tree().create_timer(time - 0.1,false).timeout
	wincheck()

func _process(delta):
	if $Beer.position.y > 674:
		$Beer.position.y -= ($Pour.scale.x * 200) * delta
	else:
		$Beer.position.y = 674
		$Lever.disabled = true
		var tween = create_tween()
		tween.tween_property($Pour, "scale", Vector2(0,1), 0.4).set_trans(Tween.TRANS_QUAD)
		soundtoggle(false)
		set_process(false)

func wincheck():
	var goal = $Line.position.y + 216
	if $Beer.position.y > (goal - generosity) and $Beer.position.y < (goal + generosity):
		complete = true
	else:
		complete = false

func soundtoggle(on):
	if on == true:
		var tween = create_tween()
		tween.tween_property($Beer/Fill, "volume_db", 7, 0.4)
	else:
		var tween = create_tween()
		tween.tween_property($Beer/Fill, "volume_db", -30, 0.8)

func on_button_down():
	var tween = create_tween()
	tween.tween_property($Pour, "scale", Vector2(1,1), 0.65).set_trans(Tween.TRANS_QUAD)
	soundtoggle(true)
	$Handle/AnimPlayer.play("crank")
	$Handle/AnimPlayer.seek(0.0667)

func on_button_up():
	var tween = create_tween()
	tween.tween_property($Pour, "scale", Vector2(0,1), 0.9).set_trans(Tween.TRANS_QUAD)
	soundtoggle(false)
	$Handle/AnimPlayer.play_backwards("crank")
	$Handle/AnimPlayer.seek(0.2)
