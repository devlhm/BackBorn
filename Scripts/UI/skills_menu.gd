extends Node2D

@export var cam_transition_time: float
@export var main_camera: Camera2D
@export var head_camera: Camera2D
@export var hand_camera: Camera2D

var init_camera_zoom: Vector2
var init_camera_pos: Vector2
var selected_bodypart = null
var selected_camera: Camera2D
var selected_stat = null:
	set(value):
		selected_stat = value
		on_stat_selected(value)
var zooming := false
var zoomed := false
var required_lr = 600 + pow(2*PlayerStats.lvl,2)
@export var labels: Dictionary
func _ready():
	init_camera_zoom = main_camera.zoom
	init_camera_pos = main_camera.global_position
	
func _input(event):
	if event.is_action_pressed("ui_cancel") and selected_bodypart:
		if(zooming):
			return
		
		if selected_camera == head_camera:
			for part in get_tree().get_nodes_in_group("head_part"):
				part.process_mode = Node.PROCESS_MODE_INHERIT
		
		selected_camera = null
		selected_bodypart = null
		get_tree().call_group("ring", "show")
		zoom_to(main_camera, init_camera_pos, init_camera_zoom)

func _on_click_area_input_event(viewport, event, shape_idx, id):
	if event is InputEventMouseButton && event.pressed:
		print(id)
		if(zooming):
			return
		get_tree().call_group("btns", "hide")
		
		for label_path in labels.values():
			get_node(label_path).hide()
			
		if selected_bodypart and selected_camera == head_camera and zoomed:
			match(id):
				"mouth":
					selected_stat = Enums.STATS.TASTE
				"eyes":
					selected_stat = Enums.STATS.SIGHT
				"ears":
					selected_stat = Enums.STATS.HEARING
				"nose":
					selected_stat = Enums.STATS.SMELL
					
				
		bodypart_selected(id)

func bodypart_selected(id: String):
	get_tree().call_group("ring", "hide")
	

	match(id):
		"head":
			selected_camera = head_camera
			for part in get_tree().get_nodes_in_group("head_part"):
				part.process_mode = Node.PROCESS_MODE_INHERIT
		"hand":
			selected_camera = hand_camera
			selected_stat = Enums.STATS.TOUCH

	if id != "head":
		get_tree().call_group("btns_" + id, "show")
		var label = get_node(labels[id])
		label.text = str(PlayerStats.stats[selected_stat])
		label.show()
		
	selected_bodypart = id
	if selected_camera:
		zoom_to(main_camera, selected_camera.global_position,selected_camera.zoom)

func zoom_to(camera, pos, zoom):
	if (zoom == camera.zoom && pos == camera.global_position):
		return
		
	zooming = true
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(camera, "global_position", pos, cam_transition_time)
	tween.tween_property(camera, "zoom", zoom, cam_transition_time)
	tween.finished.connect(on_zoom_finish)
	
func on_zoom_finish():
	zooming = false
	zoomed = !zoomed

func level_up(stat: Enums.STATS):
	PlayerStats.lvl += 1
	PlayerStats.stats[stat] += 1
	required_lr = 600 + pow(2*PlayerStats.lvl,2)
	
	if PlayerStats.lvl == 6:
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

func on_stat_selected(stat):
	pass


func _on_add_btn_button_down():
	print("down")


func _on_set_level_btn_down(increase: bool, id: String):
	var label : Label = get_node(labels[id])
	if increase:
		label.text = str(min(int(label.text) + 1, 99))
	else:
		label.text = str(max(int(label.text) - 1, PlayerStats.stats[selected_stat]))
