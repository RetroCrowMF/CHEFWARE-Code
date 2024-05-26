extends Control

var disabled = false

func _ready():
	hide()

func _input(event):
	if Input.is_action_just_pressed("Pause") and not disabled:
		show()
		get_tree().paused = true
		$SFX.play()

func on_back_pressed():
	get_tree().paused = false
	hide()

func on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/titlescreen.tscn")

func on_quit_pressed():
	Global.save()
	get_tree().quit()
