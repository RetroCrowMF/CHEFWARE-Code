extends "res://Scripts/gamebase.gd"

var lineup = [0,1,2]
var phase = 1

func _ready():
	$Music.pitch_scale = (0.75 + (Global.gameSpeed / 4))
	lineup.shuffle()
	$Choice1.frame = lineup[0]
	$Choice2.frame = lineup[1]
	$Choice3.frame = lineup[2]
	$Wrong/Burg.frame = (Global.order[0] - 1)
	$Wrong/Side.frame = (Global.order[1] + 2)

func burg_picked(ID):
	if phase == 1:
		$Window/Burg.frame = lineup[(ID - 1)]
		$Window/Burg.show()
		$Window/Burg/AnimPlayer.play("place")
		if (lineup[(ID - 1)] + 1) == Global.order[0]:
			$Pick.play()
			phase = 2
			lineup.shuffle()
			$Choice1.frame = (lineup[0] + 3)
			$Choice2.frame = (lineup[1] + 3)
			$Choice3.frame = (lineup[2] + 3)
		else:
			lose()
	else:
		$Window/Side.frame = (lineup[(ID - 1)] + 3)
		$Window/Side.show()
		$Window/Side/AnimPlayer.play("place")
		if (lineup[(ID - 1)] + 1) == Global.order[1]:
			complete = true
			$Pick.play()
			$Choice1.hide()
			$Choice2.hide()
			$Choice3.hide()
			$Right.show()
			$Right/AnimPlayer.play("idle")
			$Win.play()
			$Right/Shake.shake(10,true)
			wrapUp.emit(1.4)
		else:
			lose()

func lose():
	$Choice1.hide()
	$Choice2.hide()
	$Choice3.hide()
	$Wrong.show()
	$Fail.play()
	$Wrong/Shake.shake(30,false)
	for i in 9999:
		$Wrong/Shake.shake(1,false)
		$Wrong/Burg/Shake.shake(0.5,false)
		$Wrong/Side/Shake.shake(0.5,false)
		await get_tree().create_timer(0.05,false).timeout
