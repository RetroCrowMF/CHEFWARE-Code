extends Node

var web = false
var difficulty = 1.0
var gameSpeed = 1.0
var rng = RandomNumberGenerator.new()
var score = 0
var combo = 0
var order = [2,3]
var drawing: Array[Array]
var bossfight = false
var inCutscene = false
var didMF = false
var particles = [preload("res://Particles/ShreddingsPart.tres"),preload("res://Particles/FruitPart.tres"),preload("res://Particles/PotatoPart.tres"),
preload("res://Particles/EmberPart.tres"),preload("res://Particles/TrashPart.tres"),preload("res://Particles/BananPart.tres")]

#Save file data
var gamesBeat = []
var candies = 0
var highScore = 0
var highCombo = 0
var beat = false
var attempts = 0
var certificate: Array[Array]

func _ready():
	SilentWolf.configure({
		"api_key": "8vqWM7dCt94HXpxZ5C41E6pmWrk0083e2tyh1DNA",
		"game_id": "CHEFWARE1",
		"log_level": 1
	})

	SilentWolf.configure_scores({
		"open_scene_on_close": "res://scenes/MainPage.tscn"
	})

func loadsave():
	var config = ConfigFile.new()
	var err = config.load("user://savedata.cfg")
	if err != OK:
		return
	# SAVE DATA
	gamesBeat = config.get_value("Save", "gamesBeat")
	candies = config.get_value("Save", "candies")
	highScore = config.get_value("Save", "highScore")
	highCombo = config.get_value("Save", "highCombo")
	beat = config.get_value("Save", "beat")
	attempts = config.get_value("Save", "attempts")
	certificate = config.get_value("Save", "certificate")
	# SETTINGS
	Settings.masterVol = config.get_value("Settings", "masterVol")
	Settings.musicVol = config.get_value("Settings", "musicVol")
	Settings.sfxVol = config.get_value("Settings", "sfxVol")
	Settings.particles = config.get_value("Settings", "particles")
	Settings.skipIntros = config.get_value("Settings", "skipIntros")
	Settings.skipDialogue = config.get_value("Settings", "skipDialogue")
	Settings.coolOptions = false
	
	fixnulls()

func save():
	var config = ConfigFile.new()
	config.set_value("Save","gamesBeat",gamesBeat)
	config.set_value("Save","candies",candies)
	config.set_value("Save","highScore",highScore)
	config.set_value("Save","highCombo",highCombo)
	config.set_value("Save","beat",beat)
	config.set_value("Save","attempts",attempts)
	config.set_value("Save","certificate",certificate)
	config.set_value("Settings", "masterVol", Settings.masterVol)
	config.set_value("Settings", "musicVol", Settings.musicVol)
	config.set_value("Settings", "sfxVol", Settings.sfxVol)
	config.set_value("Settings", "particles", Settings.particles)
	config.set_value("Settings", "skipIntros", Settings.skipIntros)
	config.set_value("Settings", "skipDialogue", Settings.skipDialogue)
	fixnulls()
	config.save("user://savedata.cfg")

func fixnulls():
	if gamesBeat == null:
		gamesBeat = []
	if candies == null:
		candies = 0
	if highScore == null:
		highScore = 0
	if highCombo == null:
		highCombo = 0
	if beat == null:
		beat = false
	if attempts == null:
		attempts = 0
	if certificate == null:
		certificate = []
	if Settings.masterVol == null:
		Settings.masterVol = 80
	if Settings.musicVol == null:
		Settings.musicVol = 100
	if Settings.sfxVol == null:
		Settings.sfxVol = 100
	if Settings.particles == null:
		Settings.particles = true
	if Settings.skipIntros == null:
		Settings.skipIntros = false
	if Settings.skipDialogue == null:
		Settings.skipDialogue = false

var masterBus = AudioServer.get_bus_index("Master")
var musicBus = AudioServer.get_bus_index("Music")
var sfxBus = AudioServer.get_bus_index("SFX")
