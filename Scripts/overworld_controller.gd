extends Node3D
class_name OverworldController

@export var player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	var dialog_components = get_tree().get_nodes_in_group("dialog_component")
	for component in dialog_components:
		component.dialog_start.connect(on_dialog_start)
		component.dialog_end.connect(on_dialog_end)

func on_dialog_start():
	player.freeze()
	
func on_dialog_end():
	player.unfreeze()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
