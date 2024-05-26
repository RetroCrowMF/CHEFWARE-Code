extends Control

@onready var color_rect: ColorRect = $ColorRect
@export var usable = true
@export var path = 0

var polylines: Array[Array]
var width: float = 6.5
var color: Color = Color.BLACK

var target_point: Vector2
var target_is_outside: bool
var weight: float = 0.3
var pen_down = false

signal done()

func _ready():
	if not usable:
		if path == 2:
			Global.loadsave()
			$Pencil.hide()
			polylines = Global.certificate
			$Sprite2D.position -= Vector2(640,465)
		else:
			polylines = Global.drawing
	if path == 2:
		$CL/Done.hide()

func _draw() -> void:
	for polyline in polylines:
		if polyline.size() >= 2:
			draw_polyline(polyline, color, width)
			if polyline:
				draw_circle(polyline[0], width/2, color)
				draw_circle(polyline[-1], width/2, color)

func _process(_delta: float) -> void:
	if usable:
		target_point = lerp(target_point, (get_global_mouse_position() - global_position), weight)
		if Input.is_action_just_pressed("Click") and is_in_rect(target_point, color_rect.get_rect()):
			if path == 2:
				$CL/Done.show()
			target_point = (get_global_mouse_position() - global_position)
			pen_down = true
			polylines.append([])
		if Input.is_action_just_released("Click"):
			pen_down = false
		if pen_down:
			if Input.is_action_pressed("Click") and is_in_rect(target_point, color_rect.get_rect()):
				polylines[-1].append(target_point)
				target_is_outside = false
			elif Input.is_action_pressed("Click") and !is_in_rect(target_point, color_rect.get_rect()) and !target_is_outside:
				polylines.append([])
				target_is_outside = true
		queue_redraw()
		pass

func is_in_rect(point: Vector2, rect2: Rect2) -> bool:
	var rect_point: Vector2 = point -rect2.position
	return (rect_point.x < rect2.size.x and 
		rect_point.y < rect2.size.y and 
		rect_point.x > 0 and
		rect_point.y > 0)

func save_art() -> void:
	if usable:
		var ofsetted_polylines: Array[Array]
		for polyline in polylines:
			ofsetted_polylines.append(polyline)
			for i in ofsetted_polylines[-1].size():
				ofsetted_polylines[-1][i] -= (color_rect.get_rect().position + Vector2(0,-21)) + color_rect.get_rect().size/2
		if path != 2:
			Global.drawing = ofsetted_polylines
		else:
			done.emit()
			Global.certificate = ofsetted_polylines
			Global.save()
			await get_tree().process_frame
			queue_free()
	else:
		hide()
		$CL.hide()
