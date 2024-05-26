extends Node2D

func on_sfx_finished():
	if Global.web:
		get_tree().change_scene_to_file("res://Scenes/titlescreen.tscn")
	else:
		get_tree().quit()
