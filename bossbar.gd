extends Control

var savedHP = 800
@export var active = true

func _ready():
	hide()
	$Mid2.hide()

func intro():
	$AnimPlayer.play("intro")
	$Fill.play()
	show()

func updatehealth(Hpmax, HP):
	if savedHP > HP and active:
		$Shake.shake(20 + ((savedHP - HP) / 26), true)
	var Per = float(HP) / float(Hpmax)
	$Mid.position = Vector2((1280*(Per)), 107)
	savedHP = HP

func _physics_process(_delta):
	$Mid2.position = lerp($Mid2.position, $Mid.position, 0.06)

func on_anim_player_finished(anim_name):
	if anim_name == "intro":
		$Shake.shake(10,false)
		$Mid2.show()
		modulate = Color(9,9,9)
		$AnimPlayer.stop()
		var tween = create_tween()
		tween.tween_property(self, "modulate", Color(1,1,1), 0.25)
		$Mid.position.x = 1280
