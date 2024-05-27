extends VBoxContainer

@export var cost_label: Label
@export var confirm_btn: Button
@export var curr_lvl_label: Label
@export var desired_lvl_label: Label

var selected_stat: Enums.STATS
var exceeding: bool = false
signal level_up_req(stat, amt, cost)

func _ready():
	confirm_btn.button_down.connect(on_confirm_btn_down)

func reset(stat: Enums.STATS):
	exceeding = false
	selected_stat = stat
	cost_label.text = "0"
	curr_lvl_label.text = str(PlayerStats.stats[stat])
	desired_lvl_label.text = curr_lvl_label.text
	
func on_stat_selected(stat: Enums.STATS):
	reset(stat)

func on_desired_lvl_changed(val: int, stat: Enums.STATS, cost: int, excd: bool):
	exceeding = excd
	if exceeding:
		print("exceeding")
		
	cost_label.text = str(cost)
	desired_lvl_label.text = str(val)

func on_confirm_btn_down():
	var amt = int(desired_lvl_label.text) - PlayerStats.stats[selected_stat]
	if amt > 0 && !exceeding:
		level_up_req.emit(selected_stat, amt, int(cost_label.text))
		reset(selected_stat)
