extends Node2D

var damage = 95
var picked = false
var shreds = 0
var quota = 30 # must be odd number
var done = false

signal dodamage(damage)

func _ready():
	$Shreddings.emitting = false
	$Fruit/Shake.active = false
	$Grater.hide()
	$Fruit.hide()
	$Prop.show()
	$Fruit.frame = 0

func on_pickup():
	picked = true
	$Prop.hide()
	$CL/Button.disabled = true
	$Grater.show()
	$Fruit.show()
	$Grater/Area2D/CollShape.disabled = false

func _process(_delta):
	if picked and not done:
		$Fruit.position.y = get_global_mouse_position().y
		$Grater.position.y = (get_global_mouse_position().y * -1) + 1280

func shred(area):
	if not area.is_in_group("Sword"):
		shreds += 1
		$Shred.play()
		var lastshreds = shreds
		if Settings.particles:
			$Shreddings.emitting = true
			await get_tree().create_timer(0.25,false).timeout
			if lastshreds == shreds:
				$Shreddings.emitting = false
		if shreds >= (quota / 2) and shreds < quota:
			$Fruit.frame = 1
		elif shreds >= quota and not done:
			done = true
			attack()

func attack():
	$Grater/Area2D/CollShape.set_deferred("disabled", true)
	$Fruit/Area2D/CollShape.set_deferred("disabled", true)
	$Shreddings.emitting = false
	$Fruit/AnimPlayer.play("roar")
	$Fruit/Roar.play()
	$Fruit/Shake.offset = $Fruit.position
	$Fruit/Shake.active = true
	$Fruit/Shake.shake(20,true)
	await get_tree().create_timer(0.8,false).timeout
	$Fruit/Shake.active = false
	$Fruit/AnimPlayer.stop()
	$Fruit.frame = 4
	$AnimPlayer.play("fly")
	var tween = create_tween()
	tween.tween_property($Fruit, "position", Vector2(640,480),0.3)
	await tween.finished
	dodamage.emit(damage)
	$DeathPart.emitting = true
	$Fruit.hide()
	$Grater.hide()
	await get_tree().create_timer(1.8,false).timeout
	queue_free()

func delete():
	queue_free()
