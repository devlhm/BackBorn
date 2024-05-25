extends Node2D
class_name CombatManager

@export var turn_cooldown: Timer
@export var combat_ui: CombatUI
@export var player: CombatPlayer


@onready var quickItemTimers = [$QuickItemCooldown1, $QuickItemCooldown2]
var can_use_quick_items = [false, false]
var can_start_turn := false
var player_turn := false
func _ready():
	for i in PlayerStats.equipped_quick_items.size():
		var quickItem = PlayerStats.equipped_quick_items[i]
		if !quickItem: continue
		can_use_quick_items[i] = true
		quickItem = quickItem as QuickItem
		quickItemTimers[i].wait_time = quickItem.cooldown
		
		if quickItem.has_method("on_combat_start"):
			quickItem.on_combat_start(player)
	
	player.health_changed.connect(combat_ui.on_plr_health_changed)
	combat_ui.player = player
	combat_ui.turn_ended.connect(on_turn_end)
	
func _process(delta):
	pass
	
func _input(event):
	if event.is_action_pressed("combat_start_turn") && can_start_turn:
		start_turn()
		player_turn = true
	elif event.is_action_pressed("quick_item_1") && can_use_quick_items[0]:
		PlayerStats.equipped_quick_items[0].use(null)
		quickItemTimers[0].start()
	elif event.is_action_pressed("quick_item_2") && can_use_quick_items[1]:
		PlayerStats.equipped_quick_items[1].use(null)
		quickItemTimers[1].start()

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

func _on_quick_item_cooldown(index: int):
	can_use_quick_items[index] = true
