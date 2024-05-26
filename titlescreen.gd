extends Node2D

var altBG = preload("res://Art/Backgrounds/BGTitle2.png")

func _ready():
	Global.loadsave()
	Settings.apply()
	Global.inCutscene = false
	$Options.updatesliders()
	$EndlessWin.hide()
	$Scores.text = str("Highscore  -  ", Global.highScore, "\nBest  Combo  -  ", Global.highCombo)
	if Global.web:
		$VBoxContainer/Quit.disabled = true
	var tree = Global.rng.randi_range(1,13)
	if tree == 1:
		$BG.texture = altBG
	if Settings.skipIntros or Global.didMF:
		$Panel.queue_free()
	else:
		Global.didMF = true
		await get_tree().create_timer(1.65,false).timeout
	if Global.beat:
		$Certif.show()
	$AnimPlayer.play("Intro")

func on_start_pressed():
	if not Global.beat:
		get_tree().change_scene_to_file("res://Scenes/loadingscreen.tscn")
	else:
		$Button.play()
		$EndlessWin.show()


func on_options_pressed():
	$Options.show()
	$Button.play()

func on_quit_pressed():
	Global.save()
	get_tree().quit()

func wakeup():
	$Title.modulate = Color(1,1,1,1)
	$VBoxContainer.modulate = Color(1,1,1,1)
	$Version.modulate = Color(1,1,1,1)
	$Scores.modulate = Color(1,1,1,1)
	$UIFade.stop()
	$UIFade.start()

func on_ui_fade():
	var tween = create_tween()
	tween.tween_property($Title, "modulate", Color(1,1,1,0), 3)
	tween = create_tween()
	tween.tween_property($VBoxContainer, "modulate", Color(1,1,1,0), 3)
	tween = create_tween()
	tween.tween_property($Scores, "modulate", Color(1,1,1,0), 3)
	tween = create_tween()
	tween.tween_property($Version, "modulate", Color(1,1,1,0), 3)

var mog = 0

func _input(_event):
	wakeup()
	if Input.is_key_pressed(KEY_G) and mog == 2:
		get_tree().change_scene_to_file("res://Scenes/mog.tscn")
	if Input.is_key_pressed(KEY_O) and mog == 1:
		mog = 2
	if Input.is_key_pressed(KEY_M):
		mog = 1


func on_yes_pressed():
	Settings.endless = true
	get_tree().change_scene_to_file("res://Scenes/loadingscreen.tscn")

func on_no_pressed():
	Settings.endless = false
	get_tree().change_scene_to_file("res://Scenes/loadingscreen.tscn")

func twitter():
	OS.shell_open("https://twitter.com/MaceFaceGames")

func discord():
	OS.shell_open("https://discord.gg/E3sA9GJBUJ")

func on_certif_pressed():
	$Notepad.show()
	$Notepad/CL.show()
	$Notepad/CL/Done.show()
