extends Node2D

@onready var images = [preload("res://Art/Ads/ComputerAd1.png"),preload("res://Art/Ads/ComputerAd2.png"),preload("res://Art/Ads/ComputerAd3.png"),
preload("res://Art/Ads/ComputerAd4.png"),preload("res://Art/Ads/ComputerAd5.png"),preload("res://Art/Ads/ComputerAd6.png"),preload("res://Art/Ads/ComputerAd7.png"),
preload("res://Art/Ads/ComputerAd8.png")]

func _ready():
	$Sprite2D.texture = images[Global.rng.randi_range(0,(images.size() - 1))]

func on_button_pressed():
	queue_free()
