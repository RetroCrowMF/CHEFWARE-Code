extends Node2D

@onready var fxHit = preload("res://Scenes/fxhit.tscn")

var difficulty = 1.12
var hits = 0
var quota = 0
var targetX = 640
var targetY = 480
var toPlayer = true
var damage = 90

signal dodamage(damage)
signal hitme()
signal playerpass()

func _ready():
	await get_tree().create_timer(1.25,false).timeout
	passed()

func passed():
	difficulty *= 0.95
	$AnimPlayer.speed_scale = (1 / difficulty)
	$Fizz.play()
	if toPlayer:
		fxhit(Vector2(0.9,0.9),-1)
		$AnimPlayer.play("bounceTo")
		$BossHit.play()
		targetX = Global.rng.randf_range(100,1180)
		targetY = 745
	else:
		playerpass.emit()
		fxhit(Vector2(1.6,1.6),0)
		$AnimPlayer.play("bounceBack")
		$PlayerHit.play()
		targetX = 640
		targetY = 520
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(targetX,targetY),difficulty)
	await tween.finished
	if toPlayer and $Area2D.has_overlapping_areas():
		toPlayer = false
		passed()
	elif toPlayer:
		get_parent().playerhurt(position,Color(1,1,0,1))
		queue_free()
	elif not toPlayer and hits < quota:
		hits += 1
		hitme.emit()
		toPlayer = true
		passed()
	else:
		dodamage.emit(damage)
		queue_free()

func fxhit(hitScale,layer):
	var hit = fxHit.instantiate()
	get_parent().add_child(hit)
	hit.global_position = position
	hit.z_index = layer
	hit.scale = hitScale
