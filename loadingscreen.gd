extends Node2D

func _ready():
	if Settings.particles:
		for p in Global.particles:
			$Particles.process_material = p
			$Particles.restart()
			await get_tree().process_frame
	get_tree().change_scene_to_file("res://Scenes/kitchen.tscn")
