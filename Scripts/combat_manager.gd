extends Node2D
class_name CombatManager

@export var turn_cooldown: Timer
@export var combat_ui: CombatUI
@export var player: CombatPlayer

var can_start_turn := false

func _ready():
	combat_ui.player = player
	combat_ui.turn_ended.connect(on_turn_end)
	
func _process(delta):
	pass
	
func _input(event):
	if event.is_action_pressed("combat_start_turn") && can_start_turn:
		start_turn()

func start_turn():
	can_start_turn = false
	get_tree().paused = true
	combat_ui.on_turn_start()

func _on_turn_cooldown_timeout():
	can_start_turn = true

func on_turn_end():
	turn_cooldown.start()
