extends Node2D
class_name SkillsMenu

#TODO organizar melhor a ui das setinhas e label

var selected_bodypart

@export var ui_side: VBoxContainer
@export var char_side: SubViewportContainer

func _ready():
	for part in get_tree().get_nodes_in_group("bodypart"):
		part.selected.connect(on_bodypart_selected)
		part.selected.connect(func(_bodypart, stat): ui_side.on_stat_selected(stat))
		part.desired_lvl_changed.connect(ui_side.on_desired_lvl_changed)
	
	ui_side.level_up_req.connect(level_up)
	
func _input(event):
	if event.is_action_pressed("ui_cancel") and char_side.selected_camera:
		if(char_side.zooming):
			return
			
		selected_bodypart.deselect()
		
		char_side.on_cancel()
		ui_side.reset()

static func get_required_lr(lvl, lvl_max = null):
	if(lvl_max):
		var acc: int = 0

		for i in range(lvl + 1, lvl_max + 1):
			acc += 600 + pow(2*i, 2)
		return acc
		
	return 600 + pow(2*lvl, 2)

func level_up(stat: Enums.STATS, amt: int, cost: int):
	if PlayerStats.lvl < 6 and PlayerStats.lvl + amt >= 6:
		match stat:
			Enums.STATS.SIGHT:
				PlayerStats.attributes.int += 2
				PlayerStats.attributes.spirit += 1
			Enums.STATS.HEARING:
				PlayerStats.attributes.spirit += 2
				PlayerStats.attributes.char += 1
				PlayerStats.attributes.stamina += 1
			Enums.STATS.SMELL:
				PlayerStats.attributes.const += 2
				PlayerStats.attributes.vigor += 1
				PlayerStats.attributes.stamina += 1
			Enums.STATS.TASTE:
				PlayerStats.attributes.char += 2
				PlayerStats.attributes.vigor += 2
				PlayerStats.attributes.stamina += 1
			Enums.STATS.TOUCH:
				PlayerStats.attributes.strength += 2
				PlayerStats.attributes.const += 1
				PlayerStats.attributes.stamina += 1
				
	PlayerStats.lvl += amt
	PlayerStats.stats[stat] += amt
	PlayerStats.lr -= cost

func on_bodypart_selected(bodypart: SkillBodypart, stat):
	selected_bodypart = bodypart
	ui_side.select(stat)
