extends Resource
class_name Dialogue


@export var lines : Array[DialogueLine]
@export var end_time = 10.0


#func SetOperationAandB(i,a,b):
	#dialogue_operation[i].SetAValue(a)
	#dialogue_operation[i].SetAValue(b)
#func CanDialogue():
	#for i in dialogue_operation:
		#if i.GetResult() == false:
			#return false
	#return true

func GetLine(index : int) -> DialogueLine:
	return lines[index]
func GetSize() -> int:
	return lines.size()
func AddLine(_line : DialogueLine):
	lines.append(DialogueLine)
