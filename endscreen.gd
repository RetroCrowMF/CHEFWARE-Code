extends Control

var player_name = ""
var bannedNames = ["","NIGR","FAGT","FAG","NIGA","NIGG","NGGR","FAGG","FAG_","F@G","N/GR","N/GA","DYKE","ŅIGR","ŅIGA"]

func start():
	$AnimPlayer.play("intro")
	show()
	$Board1/Score.text = str(Global.score)
	if Global.score >= Global.highScore:
		$Board1/Score["theme_override_colors/font_outline_color"] = Color(1,0.5,0,1)
		$Board1/Score.modulate = Color(1,1,0.78,1)
		$Board1/LineEdit.show()
		$Board1/Submit.show()
		$Board1/VBox.hide()
		$Highscore.play()
	else:
		$Board1/Score["theme_override_colors/font_outline_color"] = Color(1,0.5,0,0)
		$Board1/Score.modulate = Color(1,1,1,1)
		$Board1/LineEdit.hide()
		$Board1/Submit.hide()
		$Board1/VBox.show()


func _ready():
	hide()
	#start()

func on_submit_pressed():
	if $Board1/LineEdit.text.to_upper() in bannedNames:
		$Error.play()
	else:
		$Board1/Submit.hide()
		$Board1/LineEdit.hide()
		$Board1/LineEdit.editable = false
		player_name = $Board1/LineEdit.text
		SilentWolf.Scores.save_score(player_name, Global.score)
		$Board2/Leaderboard.clear_leaderboard()
		$Board2/Leaderboard._ready()
		$SubmitSFX.play()
		$Type.play()
		$Board1/VBox.show()

func on_line_text_changed(new_text):
	if new_text == "":
		$Board1/Submit/MainMenu.show()
	else:
		$Board1/Submit/MainMenu.hide()
	$Type.play()

func on_retry_pressed():
	get_tree().change_scene_to_file("res://Scenes/kitchen.tscn")

func on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/titlescreen.tscn")
