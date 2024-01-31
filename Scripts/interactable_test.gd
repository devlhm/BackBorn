extends Node3D

@onready var interactable_component = $InteractableComponent as InteractableComponent
@onready var dialog_component = $DialogComponent as DialogComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	interactable_component.interact.connect(on_interact)
	dialog_component.dialog_end.connect(on_dialog_end)
	
func on_interact():
	dialog_component.start()
	interactable_component.set_process_input(false)

func on_dialog_end():
	interactable_component.set_process_input(true)
