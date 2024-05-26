extends RichTextLabel
class_name TextBox

@export_category("Nodes")
#@export var name_lebel : Label
@export var audio : AudioStreamPlayer
@export var timer : Timer
#@export var box : NinePatchRect
@export_category("Resources")
@export var dialogue : Dialogue
@export_category("")

#var box_height = 0
var variable_replacement : Dictionary

var index = 0

var mousein

var dialoguing = false
var dialogue_done = false
var complete = false
signal step(c)
signal dialogue_finished
signal do_dialogue()
signal setAnim(animation:String)
# Called when the node enters the scene tree for the first time.
func _ready():
	step.connect(PlayTextSound)
	#DoDialogue()

func UpdateReplace(key:String,value:String):
	variable_replacement[key] = value

func StartDialogue(dialogue:Dialogue = self.dialogue):
	index = 0
	#size.y = 56
	self.dialogue = dialogue
	#size.x = dialogue.GetLine(index).GetWidth()
	dialoguing = false
	dialogue_done = false
	complete = false
	timer.stop()
	#var tween = create_tween()
	#tween.set_ease(Tween.EASE_OUT)
	#tween.set_trans(Tween.TRANS_SINE)
	#tween.tween_property(self, "scale:y", 1.0,0.25)
	show()
	DoDialogue()
	
func DoDialogue():
	if dialogue != null:
		do_dialogue.emit()
		if dialogue_done:
			dialogue_done = false
		if dialogue.GetSize() > index:
			if not dialogue_done:
				if not dialoguing:
					dialoguing = true
					text = dialogue.GetLine(index).GetText().format(variable_replacement)
					#name_lebel.text = dialogue.GetLine(index).GetName()
					visible_ratio = 0
					visible_characters = 0
					#var tween = create_tween()
					#tween.tween_property(self, "size",Vector2(dialogue.GetLine(index).GetWidth(),56),0.5)
					#await tween.finished
					var tl = get_parsed_text().replace(" ", "")
					var ci = 0
					for i in tl.length():
						
						if dialoguing == false:
							return
						visible_characters += 1
						ci += check_if_space(ci,false)
						step.emit(tl[i])
						#$Label.text = str("i: ",i," ci:",ci)
				
						await get_tree().create_timer(0.033/dialogue.GetLine(index).GetSpeedMultiplier(),false).timeout
						ci+= 1
					dialoguing = false
				else:
					dialoguing = false
					var tween = create_tween()
					tween.tween_property(self,"visible_ratio",1.0,0)
				if dialogue_done:
					return
				dialogue_done = true
				if not dialogue.GetSize()-1 > index:
					index += 1
					End()
				else:
					await do_dialogue
					index += 1
				if dialogue.GetSize() > index:
					setAnim.emit(dialogue.GetLine(index).animation)
		else:
			End()
func check_if_space(i,s):
	if dialoguing:
		var c = get_parsed_text()[i]
		
		if c == " ":
			visible_characters += 1
			
			var pee = check_if_space(i+1,true)
			if s:
				return pee
			return pee - i
		else:
			if s:
				return i
		return 0


#func _physics_process(delta):
#
	#if dialogue != null:
		#var oset = size
		#if dialogue.GetSize()>index:
#
			#position = lerp(position,dialogue.GetLine(index).GetPosition() - oset,0.1) + Vector2(0.0, cos(Time.get_ticks_msec()*delta/16))
		#else:
			#position = lerp(position,dialogue.GetLine(dialogue.GetSize()-1).GetPosition() - oset,0.1) + Vector2(0.0, cos(Time.get_ticks_msec()*delta/16))


func End():
	if not complete:
		complete = true
		timer.start(dialogue.end_time)
		await timer.timeout
		End()
	else:
		dialogue_finished.emit()
		#var tween = create_tween()
		#tween.set_ease(Tween.EASE_OUT)
		#tween.set_trans(Tween.TRANS_SINE)
		#tween.tween_property(self, "scale:y", 0.0,0.5)
		#await tween.finished
		if complete:
			hide()
func ForceEnd():
	complete = true
	End()
func PlayTextSound(c:String):
	var sound = dialogue.GetLine(index).GetSound(c)
	if audio.stream != sound and sound != null:
		audio.stream = sound
	if sound != null:
		audio.play()

#func strip_bbcode(source:String) -> String:
	#var regex = RegEx.new()
	#regex.compile("\\[.+?\\]")
	#return regex.sub(source, "", true)
