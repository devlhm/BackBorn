extends Area3D
class_name InteractableComponent

signal interact

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(false)

func _input(event):
	if event.is_action_pressed("interact"):
		interact.emit()

func _on_body_entered(body):
	if(body.is_in_group("player")):
		set_process_input(true)

func _on_body_exited(body):
	if(body.is_in_group("player")):
		set_process_input(false)
