extends Node3D
class_name CombatManager

@export var turn_cooldown: Timer
@export var combat_ui: CombatUI

@onready var quickItemTimers = [$QuickItemCooldown1, $QuickItemCooldown2]
var can_use_quick_items = [false, false]
var can_start_turn := false
var player_turn := false
var in_combat := false
var player
signal combat_started

func _ready():		
	combat_ui.turn_ended.connect(on_turn_end)

	for i in PlayerStats.equipped_quick_items.size():
		var quickItem = PlayerStats.equipped_quick_items[i]
		if !quickItem: continue

		can_use_quick_items[i] = true
		quickItemTimers[i].wait_time = quickItem.cooldown
	
func _input(event):
	if event.is_action_pressed("combat_start_turn") && can_start_turn && in_combat:
		
		start_turn()
		player_turn = true
	elif event.is_action_pressed("quick_item_1") && can_use_quick_items[0]:
		PlayerStats.equipped_quick_items[0].use(null)
		quickItemTimers[0].start()
	elif event.is_action_pressed("quick_item_2") && can_use_quick_items[1]:
		PlayerStats.equipped_quick_items[1].use(null)
		quickItemTimers[1].start()

func set_player(plr):
	player = plr
	for i in PlayerStats.equipped_quick_items.size():
		var quickItem = PlayerStats.equipped_quick_items[i]
		if !quickItem: continue

		if quickItem.has_method("on_combat_start"):
			quickItem.on_combat_start(player)

func start_turn():
	can_start_turn = false
	get_tree().paused = true
	combat_ui.on_turn_start()

func _on_turn_cooldown_timeout():
	can_start_turn = true

func on_turn_end():
	get_tree().paused = false
	turn_cooldown.start()
	player_turn = false

func _process(delta):
	if in_combat:
		var progress = 1 - (turn_cooldown.time_left / turn_cooldown.wait_time)
		combat_ui.update_turn_indicator(progress)

func start_combat(plr: Player):
	player = plr

	get_tree().paused = false
	turn_cooldown.start()
	player_turn = false

	combat_ui.on_combat_start()
	in_combat = true
	combat_started.emit()

	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy = enemy as CombatEnemy
		enemy.player = player
		enemy.death.connect(player.on_enemy_death)
		enemy.on_combat_start()

func end_combat():
	in_combat = false

func _on_quick_item_cooldown(index: int):
	can_use_quick_items[index] = true