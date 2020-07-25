extends CanvasLayer



func _on_HideTextButton_pressed():
	$V.visible = false


func _on_LinkButton_pressed():
	print("Going")
	OS.shell_open("http://designoriented.net/")
