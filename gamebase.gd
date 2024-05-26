extends Node2D

class_name game

@onready var candy = preload("res://Scenes/Candies/candybasic.tscn")

@export var complete = false
@export var time = 5.0
@export var instruction = ""
@export var camOverride = false
signal wrapUp(wait)

func candyspawn(count):
	var can = candy.instantiate()
	for i in count:
		add_child(can)
		can.global_position.x = Global.rng.randf_range(65,1200)
		can.global_position.y = Global.rng.randf_range(60,875)
