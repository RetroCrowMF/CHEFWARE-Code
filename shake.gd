extends Node
class_name Shake

@export var ShakePath : NodePath
@export var offset : Vector2
@export var active = true
var Shaker : Node = null
var Magnitude = 0.0
var ShakeTime = 0.0

signal shake_finished

func _ready():
	SetShaker(ShakePath)

func shake(magnitude:float, override = true):
	if override:
		Magnitude = magnitude
	else:
		Magnitude += magnitude
	
func SetShaker(shakePath:NodePath):
	ShakePath = shakePath
	Shaker = get_node(ShakePath)

func _physics_process(delta):
	if active:
		if Magnitude > 0.01:
			ShakeTime += delta
			Magnitude = lerp(Magnitude,0.0,0.1)
			Shaker.position.x = cos(ShakeTime * 100) * Magnitude + offset.x
			Shaker.position.y = sin(ShakeTime* 75) * Magnitude + offset.y
		else:
			Shaker.position = offset
			emit_signal("shake_finished")
