tool
extends KinematicBody


const unselected: Material = preload("res://UnSelectedSphere.material")
const selected: Material = preload("res://SelectedSphere.material")

export var texture: Texture setget set_texture
export var display_text: String = "Sample Text" setget set_display_text

var _dragging: bool = false
var _time: float = 0.0
var _set_for_mobile: bool = false
onready var _label: Label = $LabelViewport/CanvasLayer/Label
onready var _image_viewport: Viewport = $ImageViewport
onready var _mesh: MeshInstance = $MeshInstance
var _mouse_inside: bool = false

func set_texture(new_texture: Texture):
	texture = new_texture
	if _image_viewport != null:
		_image_viewport.get_node("CustomImageLayer/MarginContainer/Texture").texture = texture

func set_display_text(new_display_text: String):
	display_text = new_display_text
	if _label != null:
		_label.text = display_text

func _ready():
	self.display_text = display_text
	self.texture = texture
	_mesh.material_override = unselected

func _process(delta):
	if Engine.editor_hint:
		set_process(false)
		return
	_time += delta
	if not _dragging:
		translation.y += sin(_time*0.5 + translation.x + translation.z)*0.005

func _on_SelectionSphere_mouse_entered():
	$HoverPlayer.play()
	_mouse_inside = true
	_mesh.material_override = selected

func _on_SelectionSphere_mouse_exited():
	_mouse_inside = false
	_mesh.material_override = unselected

func _input(event):
	if Engine.editor_hint:
		set_process_input(false)
		return
	if not _set_for_mobile and event is InputEventScreenDrag: # on mobile
		_set_for_mobile = true
		$CollisionShape.shape.radius = 0.5
	if _dragging and (event is InputEventMouseMotion or event is InputEventScreenDrag):
		var camera: Camera = get_viewport().get_camera()
		var movement_begin: Vector2 = event.position - event.relative
		var movement_end: Vector2 = event.position
		var distance: float = global_transform.origin.distance_to(camera.global_transform.origin)
		
		var movement_begin_3d: Vector3 = camera.project_position(movement_begin, distance)
		var movement_end_3d: Vector3 = camera.project_position(movement_end, distance)
		
		move_and_collide(movement_end_3d - movement_begin_3d)
	elif (_is_start_of_drag(event, true) or _is_start_of_drag(event, false)) or event.is_action("interact"):
#		print("potential drag")
		if event.is_pressed():
			if _mouse_inside:
				_dragging = true
				get_tree().set_input_as_handled()
		elif not event.is_pressed():
			_dragging = false
#		_dragging = event.is_pressed()

func _is_start_of_drag(event: InputEvent, pressed: bool):
	return (event is InputEventScreenTouch and event.pressed == pressed and event.index == 0)
