extends Node2D
class_name SkillBodypart

@export var stat: Enums.STATS
@export var label: Label
@export var add_btn: Button
@export var rmv_btn: Button
@export var click_area: Area2D

var desired_lvl: int
var exceeding: bool = false
signal selected(bodypart, stat)
signal desired_lvl_changed(val, stat, cost, exceeding)

# Called when the node enters the scene tree for the first time.
func _ready():
	deselect()
	
	click_area.input_event.connect(func(viewport, event, shape_idx):
		if event is InputEventMouseButton && event.pressed:
			select()
	)
	
	add_btn.button_down.connect(func():
		lvl_btn_down(true)
	)
	
	rmv_btn.button_down.connect(func():
		lvl_btn_down(false)
	)

func select():
	exceeding = false
	desired_lvl = PlayerStats.stats[stat]
	label.text = str(desired_lvl)
	
	selected.emit(self, stat)
	label.show()
	add_btn.show()
	rmv_btn.show()
	
func deselect():
	label.hide()
	add_btn.hide()
	rmv_btn.hide()
	
func lvl_btn_down(increase: bool):
	if increase:
		if !exceeding:
			desired_lvl = min(desired_lvl + 1, 99)

	else:
		desired_lvl = max(PlayerStats.stats[stat], desired_lvl - 1)
		exceeding = false
		
	var new_plr_lvl = PlayerStats.lvl + ((desired_lvl) - PlayerStats.stats[stat])
	var req_lr = SkillsMenu.get_required_lr(PlayerStats.lvl, new_plr_lvl)
	
	if req_lr > PlayerStats.lr && !exceeding:
		exceeding = true
		
	label.text = str(desired_lvl)
	desired_lvl_changed.emit(stat, desired_lvl, req_lr, exceeding)
