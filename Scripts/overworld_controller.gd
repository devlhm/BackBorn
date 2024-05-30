extends Node3D
class_name OverworldController

@export var player: Player
@export var combat_ui: CombatUI
@export var combat_manager: CombatManager

# Called when the node enters the scene tree for the first time.
func _ready():
	combat_manager.set_player(player)

	player.health_changed.connect(combat_ui.on_plr_health_changed)

	var dialog_components = get_tree().get_nodes_in_group("dialog_component")
	for component in dialog_components:
		component.dialog_start.connect(on_dialog_start)
		component.dialog_end.connect(on_dialog_end)

	#combat_manager.start_combat(player)

func on_dialog_start():
	player.freeze()
	
func on_dialog_end():
	player.unfreeze()
