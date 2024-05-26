extends "res://Scripts/gamebase.gd"

var quota = 4
var chops = 0

@onready var note = preload("res://Scenes/rhythmnote.tscn")

func _ready():
	#Global.gameSpeed = 1
	if Global.difficulty > 1.2:
		$Hard.show()
	Engine.time_scale = Global.gameSpeed
	$Music.pitch_scale = Global.gameSpeed
	$Label.text = str(chops, " / ", quota)
	$Label.modulate = Color(1,1,1,1)
	notespawn()
	$Music.play()

func notehit(inaccuracy):
	if inaccuracy <= 90:
		chops += 1
		if chops == quota:
			complete = true
			$Label.modulate = Color(0.75,1,0.75,1)
		$AnimPlayer.stop()
		$AnimPlayer.play("chop")
		$Cut.play()
		$Particles1.restart()
		$Label.text = str(chops, " / ", quota)
		if abs(inaccuracy) <= 14:
			$NoteScore.text = "Perfect!"
			$NoteScore.self_modulate = Color(1,1,0.75,1)
		else:
			$NoteScore.text = "Nice!"
			$NoteScore.self_modulate = Color(1,0.75,1,1)
		$NoteScore/AnimPlayer.play("anim")
	else:
		notemiss()

func notemiss():
	$NoteScore.text = "Miss"
	$NoteScore.self_modulate = Color(1,0.5,0.5,1)
	$NoteScore/AnimPlayer.play("anim")

func notespawn():
	await get_tree().create_timer(0.4922,false).timeout
	var nt = note.instantiate()
	add_child(nt)
	nt.hit.connect(notehit)
	nt.miss.connect(notemiss)
	notespawn()
	$Label/AnimPlayer.play("bounce")
