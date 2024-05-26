extends Control

func on_back_pressed():
	Global.save()
	$Button.play()
	hide()

func vol_master_changed(value):
	Settings.masterVol = value
	if value == 0.0:
		AudioServer.set_bus_mute(Global.masterBus, true)
		updatesliders()
	else:
		AudioServer.set_bus_mute(Global.masterBus, false)
		AudioServer.set_bus_volume_db(Global.masterBus, (-30.0 + (40.0 * (Settings.masterVol / 100.0))))
		updatesliders()

func vol_music_changed(value):
	Settings.musicVol = value
	if value == 0.0:
		AudioServer.set_bus_mute(Global.musicBus, true)
		updatesliders()
	else:
		AudioServer.set_bus_mute(Global.musicBus, false)
		AudioServer.set_bus_volume_db(Global.musicBus, (-30.0 + (32.0 * (Settings.musicVol / 100.0))))
		updatesliders()

func vol_sfx_changed(value):
	Settings.sfxVol = value
	if value == 0.0:
		AudioServer.set_bus_mute(Global.sfxBus, true)
		updatesliders()
	else:
		AudioServer.set_bus_mute(Global.sfxBus, false)
		AudioServer.set_bus_volume_db(Global.sfxBus, (-30.0 + (32.0 * (Settings.sfxVol / 100.0))))
		updatesliders()

func on_part_toggled(toggled_on):
	if visible:
		$Button.play()
	if toggled_on:
		Settings.particles = true
	else:
		Settings.particles = false
	updatesliders()

func on_skip_toggled(toggled_on):
	if visible:
		$Button.play()
	if toggled_on:
		Settings.skipIntros = true
	else:
		Settings.skipIntros = false
	updatesliders()

func on_dial_toggled(toggled_on):
	if visible:
		$Button.play()
	if toggled_on:
		Settings.skipDialogue = true
		if not Global.beat:
			$DialWarning.show()
	else:
		Settings.skipDialogue = false
		$DialWarning.hide()
	updatesliders()

func on_cool_toggled(toggled_on):
	if toggled_on:
		Settings.coolOptions = true
		cooltoggle(true)
	else:
		Settings.coolOptions = false
		cooltoggle(false)
	updatesliders()

func on_default_pressed():
	if visible:
		$Button.play()
	Settings.particles = true
	Settings.skipIntros = false
	Settings.skipDialogue = false
	Settings.coolOptions = false
	vol_master_changed(80.0)
	vol_music_changed(100.0)
	vol_sfx_changed(100.0)
	cooltoggle(false)
	updatesliders()

func updatesliders():
	$VolMaster.value = Settings.masterVol
	$VolMusic.value = Settings.musicVol
	$VolSFX.value = Settings.sfxVol
	$TogPart.button_pressed = Settings.particles
	$TogSkipIntros.button_pressed = Settings.skipIntros
	$TogSkipDial.button_pressed = Settings.skipDialogue
	$TogCool.button_pressed = Settings.coolOptions
	Settings.apply()

func cooltoggle(on):
	if on:
		$Title.frame = 1
		$FoodPattern.modulate = Color(0,1,1)
		$VolLabel.text = "[center][rainbow][tornado]Master\nMusic\nSound"
		$Light/AnimPlayer.play("idle")
		$Light.show()
		$Light2.show()
		$Cool.play()
	else:
		$Title.frame = 0
		$FoodPattern.modulate = Color(1,1,1)
		$VolLabel.text = "[center]Master\nMusic\nSound"
		$Light/AnimPlayer.stop()
		$Light.hide()
		$Light2.hide()
