extends ImmediateGeometry

const LINE_THICKNESS: float = 0.03

func _process(_delta):
	clear()
	begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in get_children().size() - 1:
		for offset in [Vector3(0, LINE_THICKNESS, 0), Vector3(LINE_THICKNESS, 0, 0), Vector3(0, 0, LINE_THICKNESS)]:
			_draw_quad(get_child(i).transform.origin, get_child(i + 1).transform.origin, offset)
	end()

#
#  * *  <--- upper start
#  *    *
#  * ***** <--- lower start triangle one 
#
func _draw_quad(start: Vector3, end: Vector3, offset: Vector3):
	# first triangle
	add_vertex(start + offset)
	add_vertex(start - offset)
	add_vertex(end - offset)

	# second triangle
	add_vertex(end + offset)
	add_vertex(start + offset)
	add_vertex(end - offset)
