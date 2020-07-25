extends KinematicBody


const unselected: Material = preload("res://UnSelectedSphere.material")
const selected: Material = preload("res://SelectedSphere.material")
const first_words: Array = [
	"Alpha",
	"Beta",
	"Delta",
	"Epsilon",
	"Zerg",
	"Murhy",
	"Bravo",
	"Charlie",
]
const second_words: Array = [
	"Omega",
	"Prime",
]

var _dragging: bool = false
var _time: float = 0.0
var _set_for_mobile: bool = false
onready var _label: Label = $LabelViewport/CanvasLayer/Label
onready var _mesh: MeshInstance = $MeshInstance
var _mouse_inside: bool = false

func _ready():
	randomize()
	var have_second_word: bool = randf() < 0.3
	_label.text = str(first_words[randi()%first_words.size()], " ")
	if have_second_word:
		_label.text += str(second_words[randi()%second_words.size()], " ")
	_label.text += str(randi()%9 + 1)
	_mesh.material_override = unselected

func _process(delta):
	_time += delta
	if not _dragging:
		translation.y += sin(_time*0.5 + translation.x + translation.z)*0.005

func _on_SelectionSphere_mouse_entered():
	_mouse_inside = true
	_mesh.material_override = selected

func _on_SelectionSphere_mouse_exited():
	_mouse_inside = false
	_mesh.material_override = unselected

func _input(event):
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
