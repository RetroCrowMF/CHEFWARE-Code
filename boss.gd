extends Sprite2D

@onready var potato = preload("res://Scenes/potato.tscn")
@onready var fruit = preload("res://Scenes/fruit.tscn")
@onready var sword = preload("res://Scenes/sword.tscn")
@onready var explosion = preload("res://Scenes/bossexplosion.tscn")
var atk = 0# 1-potato, 2-fuits, 3-egg
var cooling = false
var HP = 600
var HPMax = 600
var potPlaced = false
var eggDiff = 3
var eggReady = false
var busy = false
var lastAtk = 3

func attack():
	if HP > 0 and not busy:
		if eggReady:
			pass
		elif atk == 3 and not eggReady:
			if eggDiff < 6:
				eggDiff += 1
			await get_tree().create_timer(1,false).timeout
			atk = Global.rng.randi_range(1,2)
		else:
			#Main attack randomization
			atk = Global.rng.randi_range(1,3)
			if atk == 3 and HP > 700:
				atk = Global.rng.randi_range(1,2)
			if atk == lastAtk:
				atk = Global.rng.randi_range(1,3)
			lastAtk = atk
		if atk == 1:
			if potPlaced:
				attack()
			else:
				$AnimPlayer.play("throw1") 
		elif atk == 2:
			swordspawn()
			$AnimPlayer.play("throw2")
		elif atk == 3:
			eggReady = true
			if $"..".atkGiven == false and not potPlaced:
				eggatk()

func cooldown(wait):
	if not cooling:
		cooling = true
		$AnimPlayer.play("idle")
		await get_tree().create_timer(wait).timeout
		attack()
		cooling = false

func hurt(damage):
	HP -= damage
	if $AnimPlayer.current_animation == "eggidle" or $AnimPlayer.current_animation == "egghit":
		busy = false
		$"..".panNode.leave()
	
	if HP > 0:
		$AnimPlayer.play("hurt")
		$Hurt.play()
	elif $AnimPlayer.current_animation != "death":
		die()

func die():
	Global.beat = true
	$Death.play()
	$AnimPlayer.play("death")
	explode()
	$"../CL/White".show()
	if potPlaced:
		$"..".potatoNode.die()

func on_anim_player_finished(anim_name):
	if anim_name == "egghit":
		$AnimPlayer.play("eggidle")
		await get_tree().process_frame
		flip_h = not flip_h
	elif anim_name == "egghitfirst":
		$AnimPlayer.play("eggidle")
	elif anim_name == "hurt":
		$AnimPlayer.play("idle")
		cooldown(0.8)
	elif anim_name == "throw1":
		$AnimPlayer.play("idle")
	elif anim_name == "death":
		$"..".boss_end()

func eggatk():
	busy = true
	eggReady = false
	get_parent().bosspanspawn()
	get_parent().bosseggspawn(eggDiff)
	$AnimPlayer.play("eggthrow")
	await get_tree().create_timer(1.25,false).timeout
	$AnimPlayer.play("egghit")
	await get_tree().process_frame
	flip_h = not flip_h

func eggfailed():
	$AnimPlayer.play("idle")
	$"..".panNode.leave()
	busy = false
	cooldown(3)

func potatodead():
	if HP > 0:
		if eggReady:
			cooldown(1.5)
		else:
			cooldown(4)
		potPlaced = false
		$"../Camera2D/Shake".shake(8,false)

func potatospawn():
	$Throw.play()
	potPlaced = true
	var pot = potato.instantiate()
	get_parent().add_child(pot)
	$"..".potatoNode = pot
	pot.death.connect(potatodead)

func swordspawn():
	var sw = sword.instantiate()
	get_parent().add_child(sw)

func fruitspawn():
	$Throw.play()
	var fru = fruit.instantiate()
	get_parent().add_child(fru)
	fru.global_position = Vector2(640,935)

func explode():
	var ex = explosion.instantiate()
	ex.global_position.x = Global.rng.randf_range(433,828)
	ex.global_position.y = Global.rng.randf_range(795,300)
	get_parent().add_child(ex)
	$Shake.shake(5,false)
	await get_tree().create_timer(0.075,false).timeout
	if $AnimPlayer.current_animation == "death":
		explode()
