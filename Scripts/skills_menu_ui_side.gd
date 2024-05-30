extends VBoxContainer

@export var cost_label: Label
@export var confirm_btn: Button
@export var curr_lvl_label: Label
@export var desired_lvl_label: Label
@export var leveling_info: HBoxContainer
@export var lr: Label

var selected_stat
var exceeding: bool = false
signal level_up_req(stat, amt, cost)


func _ready():
	confirm_btn.button_down.connect(on_confirm_btn_down)
	reset()

func reset():
	leveling_info.modulate.a = 0
	lr.text = str(PlayerStats.lr)
	selected_stat = null

func select(stat: Enums.STATS):
	leveling_info.modulate.a = 1
	
	exceeding = false
	lr.text = str(PlayerStats.lr)
	selected_stat = stat
	cost_label.text = "0"
	curr_lvl_label.text = str(PlayerStats.stats[stat])
	desired_lvl_label.text = curr_lvl_label.text

func on_stat_selected(stat: Enums.STATS):
	select(stat)

func on_desired_lvl_changed(stat: Enums.STATS, val: int, cost: int, excd: bool):
	exceeding = excd
	if exceeding:
		print("exceeding")
		
	cost_label.text = str(cost)
	desired_lvl_label.text = str(val)

func on_confirm_btn_down():
	print("confirm")
	var amt = int(desired_lvl_label.text) - PlayerStats.stats[selected_stat]
	if amt > 0 && !exceeding:
		level_up_req.emit(selected_stat, amt, int(cost_label.text))
		select(selected_stat)
