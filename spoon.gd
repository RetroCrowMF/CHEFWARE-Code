extends TextureButton

@export var ID = 1
var mySpoon = 1
var images = [preload("res://Art/Spoon0.5Tsp.png"),preload("res://Art/Spoon1TBsp.png"),preload("res://Art/Spoon1Tsp.png")]
var random = RandomNumberGenerator.new()

signal selected(mySpoon)

func on_pressed():
	selected.emit(mySpoon)
	$AnimPlayer.play("Picked")

func setspoons(spoon, order):
	if order == ID:
		mySpoon = spoon
	else:
		mySpoon = ID
		while mySpoon == spoon:
			mySpoon = random.randi_range(1,3)
	texture_normal = images[(mySpoon - 1)]
