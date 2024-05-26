extends Line2D

var length = 5

func _process(_delta):
	var pos = get_global_mouse_position()
	
	if points.size() > length:
		remove_point(0)
	else:
		add_point(pos)

