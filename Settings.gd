extends Node

var masterVol = 80.0
var musicVol = 100.0
var sfxVol = 100.0
var particles = true
var skipIntros = false
var skipDialogue = false
var coolOptions = false

var endless = false

func apply():
	if masterVol == 0.0:
		AudioServer.set_bus_mute(Global.masterBus, true)
	else:
		AudioServer.set_bus_mute(Global.masterBus, false)
		AudioServer.set_bus_volume_db(Global.masterBus, (-30.0 + (40.0 * (masterVol / 100.0))))
	
	if musicVol == 0.0:
		AudioServer.set_bus_mute(Global.musicBus, true)
	else:
		AudioServer.set_bus_mute(Global.musicBus, false)
		AudioServer.set_bus_volume_db(Global.musicBus, (-30.0 + (32.0 * (musicVol / 100.0))))
	
	if sfxVol == 0.0:
		AudioServer.set_bus_mute(Global.sfxBus, true)
	else:
		AudioServer.set_bus_mute(Global.sfxBus, false)
		AudioServer.set_bus_volume_db(Global.sfxBus, (-30.0 + (32.0 * (sfxVol / 100.0))))

