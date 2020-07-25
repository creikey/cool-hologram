extends Spatial

const MOUSE_DRAG_SPEED = 0.01
const MOUSE_ZOOM_INCREMENT = 0.04

var dragging: bool = false

var target_rotation: Vector3 = Vector3()
var target_zoom: float = 1.0

#func _process(_delta):
#	

func _input(event):
	if event.is_action_pressed("zoom_in"):
		target_zoom -= MOUSE_ZOOM_INCREMENT
	elif event.is_action_pressed("zoom_out"):
		target_zoom += MOUSE_ZOOM_INCREMENT
#	if event is InputEventMouseMotion and dragging:
#		target_rotation.x -= event.relative.y*MOUSE_DRAG_SPEED
#		target_rotation.y -= event.relative.x*MOUSE_DRAG_SPEED
#	elif event.is_action_released("interact"):
#		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
#		dragging = false

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		dragging = true
	elif event is InputEventMouseMotion and dragging:
		target_rotation.x -= event.relative.y*MOUSE_DRAG_SPEED
		target_rotation.y -= event.relative.x*MOUSE_DRAG_SPEED
	elif event.is_action_released("interact"):
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		dragging = false
	

func _process(delta):
	if Input.is_action_pressed("zoom_in"):
		target_zoom -= MOUSE_ZOOM_INCREMENT
	if Input.is_action_pressed("zoom_out"):
		target_zoom += MOUSE_ZOOM_INCREMENT
	rotation = lerp(rotation, target_rotation, 0.08)
	scale.x = lerp(scale.x, target_zoom, 0.2)
	scale.y = scale.x
	scale.z = scale.x
