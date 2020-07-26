extends Spatial

const MOUSE_DRAG_SPEED = 0.01
const MOUSE_ZOOM_INCREMENT = 0.04

var dragging: bool = false

var target_rotation: Vector3 = Vector3()
var target_zoom: float = 1.0
var rotation_smooth_factor: float = 0.08
var cur_mouse_drag_speed: float = MOUSE_DRAG_SPEED
var finger_positions: Dictionary = {
	0: Vector2(),
	1: Vector2(),
}
var started_dragging: bool = false
var initial_zoom_distance: float = 0.0
var initial_zoom: float = 1.0

func _input(event):
	if event is InputEventScreenDrag: # on mobile
		rotation_smooth_factor = 0.5
		cur_mouse_drag_speed = 0.003
		if event.index == 0:
			finger_positions[0] = event.position
			if started_dragging:
#				print(finger_positions)
				target_zoom = initial_zoom * 2.0 * (initial_zoom_distance / (finger_positions[1] - finger_positions[0]).length())
		elif event.index == 1:
			finger_positions[1] = event.position
	if event is InputEventScreenTouch and event.index == 1:
		if event.is_pressed():
			started_dragging = true
			finger_positions[1] = event.position
			initial_zoom = target_zoom
			initial_zoom_distance = (finger_positions[1] - finger_positions[0]).length() / 2.0
		else:
			started_dragging = false
#	print(event)
	if event.is_action_pressed("zoom_in"):
		target_zoom -= MOUSE_ZOOM_INCREMENT
	elif event.is_action_pressed("zoom_out"):
		target_zoom += MOUSE_ZOOM_INCREMENT
	elif event is InputEventMagnifyGesture:
		printt(event.is_pressed(), event.factor)
#	if event is InputEventMouseMotion and dragging:
#		target_rotation.x -= event.relative.y*MOUSE_DRAG_SPEED
#		target_rotation.y -= event.relative.x*MOUSE_DRAG_SPEED
#	elif event.is_action_released("interact"):
#		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
#		dragging = false

func _unhandled_input(event):
	if _is_start_of_drag(event, true) or event.is_action_pressed("interact"):
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		dragging = true
	elif (event is InputEventMouseMotion or event is InputEventScreenDrag) and dragging:
#		print(event.relative)
		target_rotation.x -= event.relative.y*cur_mouse_drag_speed
		target_rotation.y -= event.relative.x*cur_mouse_drag_speed
	elif _is_start_of_drag(event, false) or event.is_action_released("interact"):
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		dragging = false
	

func _is_start_of_drag(event: InputEvent, pressed: bool):
	return (event is InputEventScreenTouch and event.pressed == pressed and event.index == 0)

func _process(delta):
	if Input.is_action_pressed("zoom_in"):
		target_zoom -= MOUSE_ZOOM_INCREMENT
	if Input.is_action_pressed("zoom_out"):
		target_zoom += MOUSE_ZOOM_INCREMENT
	if target_rotation.distance_to(rotation) > 0.1:
		var strm: AudioStreamSample = $PanningLoop.stream
		strm.loop_mode = AudioStreamSample.LOOP_PING_PONG
		if not $PanningLoop.playing:
			$PanningLoop.play()
	elif $PanningLoop.playing:
		var strm: AudioStreamSample = $PanningLoop.stream
		strm.loop_mode = AudioStreamSample.LOOP_DISABLED
	rotation = lerp(rotation, target_rotation, rotation_smooth_factor)
	scale.x = lerp(scale.x, target_zoom, 0.2)
	scale.y = scale.x
	scale.z = scale.x
