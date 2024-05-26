extends Node2D

var target = 100
var noteRange = 200
var expired = false

signal hit(inaccuracy)
signal miss()

var tween: Tween

func _ready():
	global_position = Vector2(1325,825)
	await get_tree().process_frame
	tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self, "position", Vector2(target,825), 1.5)
	await tween.finished
	tween.stop()
	#notehit()
	tween = create_tween()
	tween.tween_property(self, "position", Vector2(8.125,825), 0.1125)
	await tween.finished
	expired = true
	miss.emit()
	$AnimPlayer.play("miss")

func _input(_event):
	if Input.is_action_just_pressed("Click") and position.x < (target + noteRange):
		notehit()

func notehit():
	if not expired:
		expired = true
		hit.emit((position.x - target))
		tween.stop()
		$AnimPlayer.play("hit")
