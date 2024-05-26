extends Node2D

#region preloads
@onready var bananas = preload("res://Scenes/bananas.tscn")
@onready var dragon = preload("res://Scenes/dragonfruit.tscn")
@onready var bossEgg = preload("res://Scenes/bossegg.tscn")
@onready var bossPan = preload("res://Scenes/bosspan.tscn")
@onready var splat = preload("res://Scenes/splat.tscn")
@onready var certif = preload("res://Scenes/certificate.tscn")
var panNode = Node
var potatoNode = Node
var bananaNode = Node
var dragFruitNode = Node

@onready var games = [preload("res://Scenes/Games/game1.tscn"),preload("res://Scenes/Games/game2.tscn"),preload("res://Scenes/Games/game3.tscn"),
preload("res://Scenes/Games/game4.tscn"),preload("res://Scenes/Games/game5.tscn"),preload("res://Scenes/Games/game6.tscn"),preload("res://Scenes/Games/game7.tscn")
,preload("res://Scenes/Games/game8.tscn"),preload("res://Scenes/Games/game9.tscn"),preload("res://Scenes/Games/game10.tscn"),preload("res://Scenes/Games/game11.tscn"),
preload("res://Scenes/Games/game12.tscn"),preload("res://Scenes/Games/game13.tscn"),preload("res://Scenes/Games/game14.tscn"),preload("res://Scenes/Games/game15.tscn")]

@onready var mess = [preload("res://Art/Backgrounds/BGMess1.png"),preload("res://Art/Backgrounds/BGMess2.png"),preload("res://Art/Backgrounds/BGMess3.png")]

@onready var preFFDialogue = preload("res://Dialogue/prefoodfight.tres")
@onready var dialogues = [preload("res://Dialogue/introduction.tres"),preload("res://Dialogue/attempt2.tres"),preload("res://Dialogue/attempt3.tres")
,preload("res://Dialogue/attempt4.tres"),preload("res://Dialogue/attempt5.tres"),preload("res://Dialogue/attempt38.tres"),
preload("res://Dialogue/attempt100.tres"),preload("res://Dialogue/standard.tres")]
@onready var endDials = [preload("res://Dialogue/end1.tres"),preload("res://Dialogue/end2.tres")]

#endregion

var switchingTo = ""
var lastGame = []
var lives = 3
var won = false
var randomness = 2
var ranGame = 0
var currentGame = 0
var testOmit = 0
var lastSec = false
var gameWon = false
var sword = null
var atkGiven = false
var started = false
var inIntro = false#true
var invincible = false
var dialCool = false
var bossQuota = 25
var certifShown = false

var orderPhase = 1

func _ready():
	Global.loadsave()
	Settings.apply()
	Global.attempts += 1
	$CL/Time.hide()
	$CL/Heart1.hide()
	$CL/ScoreBoard.hide()
	$CL/FFIntro.hide()
	$Chef.show()
	$Boss.hide()
	$CL/White.hide()
	bananaNode = null
	dragFruitNode = null
	Global.gameSpeed = 1.05
	Global.difficulty = 1.0
	Global.score = 0
	Global.combo = 0
	Global.bossfight = false
	Global.inCutscene = false
	for i in testOmit:
		games.remove_at(0)
	$CL/TextBox.position.y = 819
	if Settings.endless or Settings.skipDialogue:
		begingame()
	else:
		intro()
	#begingame()
	#cutscene()
	#$FoodFight.play()
	#foodfight()

func begingame():
	started = true
	Global.save()
	$Chef/State.play("idle")
	$CL/TextBox.hide()
	$Jingle2.play()
	await get_tree().create_timer(1.466,false).timeout
	Engine.time_scale = Global.gameSpeed
	reset_pitch()
	minigame(true)

func _process(delta):
	if $Timer.time_left > 1:
		$CL/Time.text = str(int($Timer.time_left))
		$CL/Time.add_theme_font_size_override("font_size", 160)
	else:
		if not lastSec:
			lastSec = true
			$CL/Time/AnimPlayer.play("eat")
		$CL/Time.text = str(snapped($Timer.time_left,0.1))
		$CL/Time.add_theme_font_size_override("font_size", 100)
	
	$CL/Time/Pizza.rotation += (3 + $CL/Time/Pizza.frame) * delta

func minigame(firstgame):
	if firstgame:
		$AnimPlayer.play("!FirstGameStart")
		$CL/Heart1.show()
		$CL/ScoreBoard.show()
	else:
		$AnimPlayer.play("GameStart")
	$Chef/State.play("idle")
	$CL/Instructions.text = "Get  Ready!!"
	if Global.attempts == 1:
		ranGame = 0
	else:
		# Game is randomized here
		ranGame = Global.rng.randi_range(0,(games.size() - 1))
		
	while lastGame.has(ranGame):
		ranGame = Global.rng.randi_range(0,(games.size() - 1))
	game_ordering()
	currentGame = ranGame
	lastGame.append(ranGame)
	if lastGame.size() > (games.size() - randomness):
		lastGame.remove_at(0)
	await get_tree().create_timer(0.1,false).timeout
	switchingTo = games[ranGame].instantiate()
	switchingTo.wrapUp.connect(wrapup)
	await get_tree().create_timer(1.383,false).timeout
	if switchingTo == null:
		print("game",str(ranGame)," has crashed the game")
		switchingTo = games[5].instantiate()
	if switchingTo.camOverride == true:
		$Camera2D.enabled = false
	$CL/Heart1.hide()
	$CL/ScoreBoard.hide()
	add_child(switchingTo)
	timerstart()
	$Timer.start(switchingTo.time)

func result():
	$Label.text = str(ranGame)
	$CL/Time.hide()
	$CL/Heart1.show()
	$CL/ScoreBoard.show()
	$Camera2D/Table.show()
	$Camera2D.enabled = true
	if gameWon:
		Global.score += 1
		Global.combo += 1
		if Global.score > Global.highScore:
			Global.highScore = Global.score
		if Global.combo > Global.highCombo:
			Global.highCombo = Global.combo
		if not Settings.endless and Global.score >= bossQuota:
			won = true
		$Jingle1.play()
		if not won:
			if (0.036 - (float(Global.score) / 2250)) < 0:
				Global.gameSpeed += (0.036 - (float(Global.score) / 2250)) + 0.012
				Global.difficulty += 0.1
			else:
				Global.gameSpeed += 0.011
				Global.difficulty += 0.08
			Engine.time_scale = Global.gameSpeed
			$Jingle2.play()
		else:
			Global.gameSpeed = 1.0
			Engine.time_scale = 1.0
		reset_pitch()
		update_mess()
		$Chef/State.play("win")
		$AnimPlayer.play("Win")
		$Jingle1.play()
		if not currentGame in Global.gamesBeat:
			Global.gamesBeat.append(currentGame)
		$CL/ScoreBoard/Score.text = str(Global.score)
		$CL/ScoreBoard/Combo.text = str(Global.combo)
		
	else:# Game Lost
		lives -= 1
		Global.difficulty -= 0.2
		$Jingle3.play()
		if lives <= 0:
			Global.gameSpeed = 1.0
			Engine.time_scale = 1.0
		else:
			if Global.gameSpeed > 1.05:
				Global.gameSpeed -= 0#.05
			Engine.time_scale = Global.gameSpeed
			$Jingle2.play()
		reset_pitch()
		if Global.combo > Global.highCombo:
			Global.highCombo = Global.combo
		Global.combo = 0
		$Chef/State.play("lose")
		$AnimPlayer.play("Lose")
		await get_tree().create_timer(0.85,false).timeout
		if lives == 2:
			$CL/Heart1/Heart3.hide()
			$CL/HeartParticles.position = Vector2(1195,500)
		elif lives == 1:
			$CL/Heart1/Heart2.hide()
			$CL/HeartParticles.position = Vector2(1195,660)
		elif lives == 0:
			$CL/Heart1.hide()
			$CL/HeartParticles.position = Vector2(1195,815)
		$CL/HeartParticles.emitting = true
		$CL/Heart1/Shake.shake(35,true)
		$CL/Heart1/Label.text = str(lives)
		$CL/ScoreBoard/Combo.text = str(Global.combo)
		$Hurt.play()
		if lives == 1:
			$"1HP".play()

func game_ordering():
	if ranGame == (13 - testOmit):
		if lastGame.size() > 0 and lastGame[-1] == (12 - testOmit):
			while ranGame == (12 - testOmit) or ranGame == (13 - testOmit):
				ranGame = Global.rng.randi_range(0,(games.size() - 1))
		elif orderPhase == 1:
			ranGame = (12 - testOmit)
			orderPhase = 2
		else:
			orderPhase = 1
	elif ranGame == (12 - testOmit):
		if orderPhase == 2:
			ranGame = (13 - testOmit)
			orderPhase = 1
		else:
			orderPhase = 2

func timerstart():
	$CL/Time/AnimPlayer.play("RESET")
	$CL/Time.modulate = Color(1,1,1,0)
	$CL/Time.show()
	lastSec = false
	await get_tree().create_timer(1.05 + (switchingTo.time - int(switchingTo.time)),false).timeout
	var tween = create_tween()
	tween.tween_property($CL/Time, "modulate", Color(1,1,1,1), 0.15)

func on_timer_timeout():
	gameWon = switchingTo.complete
	result()
	switchingTo.queue_free()

func wrapup(wait):
	if $Timer.time_left > wait:
		$Timer.stop()
		$Timer.start(wait)

func updateinstruction():
	$CL/Instructions.text = str("  ", switchingTo.instruction)
	$Camera2D/Table.hide()

func reset_pitch():
	$Jingle1.pitch_scale = Global.gameSpeed
	$Jingle2.pitch_scale = Global.gameSpeed
	$Jingle3.pitch_scale = Global.gameSpeed

func update_mess():
	if Global.score > 3:
		$BG/Mess.show()
		if Global.score < 10:
			$BG/Mess.texture = mess[0]
		elif Global.score < 21:
			$BG/Mess.texture = mess[1]
		else:
			$BG/Mess.texture = mess[2]

func lose():
	if Global.score > Global.highScore:
		Global.highScore = Global.score
	$CL/EndScreen.start()
	Global.save()
	if bananaNode != null:
		bananaNode.delete()
	if dragFruitNode != null:
		dragFruitNode.delete()

func foodfight():
	Global.bossfight = true
	$CL/BossBar.intro()
	$Chef.hide()
	$Boss.show()
	$Boss/AnimPlayer.play("idle")
	$CL/FFIntro.hide()
	await get_tree().create_timer(3,false).timeout
	$Boss.attack()
	await get_tree().create_timer(0.9,false).timeout
	$AtkTimer.start()

func cutscene():
	$CL/TextBox.dialogue = preFFDialogue
	if not Settings.skipDialogue:
		$CL/TextBox.position.y = 819
		$CL/TextBox.text = ""
		$AnimPlayer.play("Cutscene")
		Global.inCutscene = true
		$Cutscene.play()
		await get_tree().create_timer(0.9,false).timeout
		$CutsceneMusic.play()
		$CL/TextBox.StartDialogue()
	else:
		Global.inCutscene = true
		$CL/TextBox.index = 6
		_input(true)

func bossprepare():
	$Chef/State.stop()
	lives = 3
	$CL/Heart1.position = Vector2(1203,775)
	$CL/Heart1.modulate = Color(1,1,1,0)
	$CL/ScoreBoard/AnimPlayer.stop()
	$CL/ScoreBoard.hide()
	$Chef.hide()
	$Boss.show()
	$Boss/AnimPlayer.play("idle")

func playerattack():
	var atk = Global.rng.randi_range(1,2)
	if not $Boss.eggReady and not $Boss.busy and not atkGiven and $Boss.HP > 0:
		if atk == 1:
			bananaspawn()
		elif atk == 2:
			dragonspawn()
		atkGiven = true

func playerhurt(pos, color):
	$Camera2D/Shake.shake(5,false)
	splatspawn(pos, color)
	if lives == -1:
		$BossLose.start()
	else:
		if $Boss.busy:
			$Boss.eggfailed()
		if not invincible:
			invincible = true
			$Camera2D/Shake.shake(20,false)
			lives -= 1
			$CL/Heart1.modulate = Color(1,1,1,1)
			$CL/Heart1.show()
			$CL/Heart1.position.x = 1203
			if lives == 2:
				$CL/Heart1/Heart3.hide()
				$CL/Heart1/Heart2.show()
				$CL/HeartParticles.position = Vector2(1195,500)
			elif lives == 1:
				$CL/Heart1/Heart2.hide()
				$CL/HeartParticles.position = Vector2(1195,660)
				$"1HP".play()
			elif lives == 0:
				$CL/Heart1.hide()
				$CL/HeartParticles.position = Vector2(1195,815)
				$FoodFight.stop()
				lives = -1
				$BossLose.start()
			$CL/HeartParticles.restart()
			$CL/Heart1/Shake.shake(35,true)
			$CL/Heart1/Label.text = str(lives)
			$CL/ScoreBoard/Combo.text = str(Global.combo)
			$Hurt.play()
			if lives > 0:
				await get_tree().create_timer(1.2,false).timeout
				var tween = create_tween()
				tween.tween_property($CL/Heart1, "modulate", Color(1,1,1,0),0.5)
				await tween.finished
				invincible = false

func boss_hurt(damage):
	atkGiven = false
	bananaNode = null
	dragFruitNode = null
	if damage > 0:
		$Boss.hurt(damage)
		$CL/BossBar.updatehealth($Boss.HPMax, $Boss.HP)
		$AtkTimer.start(3.5)
	else:
		if $Boss.eggReady:
			$Boss.attack()
		$AtkTimer.start(3)

func boss_end():
	$FoodFight.stop()
	$Boss.hide()
	$Chef.show()
	$CL/BossBar.hide()
	Global.bossfight = false
	Global.inCutscene = true
	Global.save()
	await get_tree().create_timer(2.2,false).timeout
	$AnimPlayer.play("PostFF")
	await get_tree().create_timer(4.15,false).timeout
	if not Settings.skipDialogue:
		$CL/TextBox.position.y = 819
		$CL/TextBox.dialogue = endDials[0]
		$CL/TextBox.StartDialogue()
		$CL/TextBox.show()
		$EndingMus.play()
	else:
		$CL/TextBox.dialogue = null
		$AnimPlayer.play("Ending")
		await get_tree().create_timer(2.5,false).timeout
		$CL/EndScreen.start()
	

func _input(_event):
	if not Global.bossfight and not dialCool and Input.is_action_just_pressed("Click") or not Global.bossfight and not dialCool and Settings.skipDialogue:
		dialCool = true
		if not Global.inCutscene and not inIntro:
			if $CL/TextBox.index == 8:
				begingame()
			$CL/TextBox.DoDialogue()
		elif Global.inCutscene and not inIntro:
			$CL/TextBox.DoDialogue()
			if $CL/TextBox.index == 6 and $CL/TextBox.dialogue == preFFDialogue:
				$CL/TextBox.hide()
				$CL/FFIntro.position = Vector2(-10,-10)
				$CL/FFIntro/Food.text = ""
				$CL/FFIntro.show()
				$CL/FFIntro/Food.hide()
				$CL/FFIntro/Fight.hide()
				$Blackout.play()
				$CL/TextBox.position = Vector2(0,45)
				$CutsceneMusic.stop()
				await get_tree().create_timer(1,false).timeout
				$CL/TextBox.show()
				$CL/TextBox.DoDialogue()
				bossprepare()
				await get_tree().create_timer(3,false).timeout
				$CL/FFIntro/Food.show()
				$CL/FFIntro/Fight/AnimPlayer.play("idle")
				$AnimPlayer.play("FFIntro")
				await get_tree().create_timer(3.5,false).timeout
		await get_tree().create_timer(0.02,false).timeout
		dialCool = false

func intro():
	if Global.attempts == 1 and not Settings.skipIntros:
		Global.inCutscene = true
		$CL/PauseScreen.disabled = true
		$AnimPlayer.play("Intro")
		$ChefIntro.play()
		await get_tree().create_timer(10,false).timeout
		$CL/PauseScreen.disabled = false
		Global.inCutscene = false
	else:
		$Camera2D/Shake.shake(4,false)
		$Blackout.play()
		await get_tree().create_timer(1,false).timeout
	decidedialogue()
	$CL/TextBox.show()
	inIntro = false
	$CL/TextBox.StartDialogue()

func on_anim_player_finished(anim_name):
	if anim_name == "Win" or anim_name == "Lose":
		if lives == 0:
			$BossLose.start()
		elif won:
			await get_tree().create_timer(0.6,false).timeout
			cutscene()
		else:
			minigame(false)
	elif anim_name == "FFIntro":
		$CL/FFIntro.hide()
		$CL/FFIntro/Fight/AnimPlayer.stop()
		foodfight()

func on_dialogue_finished():
	if not started and not Global.inCutscene:
		begingame()
	elif $CL/TextBox.dialogue == endDials[0] and not certifShown:
		certifShown = true
		certifspawn()
		$Chef/State.play("idle")
	elif $CL/TextBox.dialogue == endDials[1] and certifShown:
		$CL/TextBox.dialogue = null
		$AnimPlayer.play("Ending")
		await get_tree().create_timer(2.5,false).timeout
		$CL/EndScreen.start()

func decidedialogue():
	if Global.attempts < 6:
		$CL/TextBox.dialogue = dialogues[(Global.attempts - 1)]
	elif Global.attempts == 38:
		$CL/TextBox.dialogue = dialogues[5]
	elif Global.attempts == 100:
		$CL/TextBox.dialogue = dialogues[6]
	else:
		$CL/TextBox.dialogue = dialogues[7]

func on_text_box_dialogue(animation):
	$Chef/State.play(animation)

func bosspassback():
	$Boss/AnimPlayer.play("egghit")

func playerpassback():
	panNode.shake()

func certifdone():
	await get_tree().create_timer(1,false).timeout
	$CL/TextBox.dialogue = endDials[1]
	$CL/TextBox.StartDialogue()
	Global.save()

func bananaspawn():
	var ban = bananas.instantiate()
	get_parent().add_child(ban)
	ban.dodamage.connect(boss_hurt)
	bananaNode = ban

func dragonspawn():
	var dra = dragon.instantiate()
	get_parent().add_child(dra)
	dra.dodamage.connect(boss_hurt)
	dragFruitNode = dra

func splatspawn(pos, color):
	var spl = splat.instantiate()
	get_parent().add_child(spl)
	spl.global_position = pos
	spl.modulate = color

func bosseggspawn(diff):
	var beg = bossEgg.instantiate()
	add_child(beg)
	beg.quota = diff
	beg.dodamage.connect(boss_hurt)
	beg.hitme.connect(bosspassback)
	beg.playerpass.connect(playerpassback)

func bosspanspawn():
	var pan = bossPan.instantiate()
	panNode = pan
	get_parent().add_child(pan)

func certifspawn():
	var crt = certif.instantiate()
	crt.done.connect(certifdone)
	get_parent().add_child(crt)
