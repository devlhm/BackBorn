extends Node2D
class_name SkillsMenu

#TODO editar textos com base na parte selecionada
#TODO adicionar funcionalidade e botao de subir o nivel
#TODO organizar melhor a ui das setinhas e label

@export var cam_transition_time: float
@export var main_camera: Camera2D
@export var head_camera: Camera2D
@export var hand_camera: Camera2D

var init_camera_zoom: Vector2
var init_camera_pos: Vector2
var selected_bodypart = null
var selected_camera: Camera2D
var selected_stat = null
var zooming := false
var zoomed := false
var required_lr = 600 + pow(2*PlayerStats.lvl,2)
@export var labels: Dictionary

func _ready():
	init_camera_zoom = main_camera.zoom
	init_camera_pos = main_camera.global_position
	
	for part in get_tree().get_nodes_in_group("bodypart"):
		part.selected.connect(on_bodypart_selected)
	
func _input(event):
	if event.is_action_pressed("ui_cancel") and selected_camera:
		if(zooming):
			return
		
		if selected_camera == head_camera:
			for part in get_tree().get_nodes_in_group("head_part"):
				part.process_mode = Node.PROCESS_MODE_DISABLED
				
		selected_bodypart.deselect()
		
		selected_camera = null
		selected_stat = null
		selected_bodypart = null
		
		get_tree().call_group("ring", "show")
		zoom_to(main_camera, init_camera_pos, init_camera_zoom)

func _on_click_area_input_event(viewport, event, shape_idx, id):
	if event is InputEventMouseButton && event.pressed:
		if(zooming):
			return
		
		for label_path in labels.values():
			get_node(label_path).hide()
			
		if selected_camera == head_camera and zoomed:
			pass
		cam_selected(id)

func cam_selected(id: String):
	get_tree().call_group("ring", "hide")

	match(id):
		"head":
			selected_camera = head_camera
			for part in get_tree().get_nodes_in_group("head_part"):
				part.process_mode = Node.PROCESS_MODE_INHERIT
		"hand":
			selected_camera = hand_camera
			selected_stat = Enums.STATS.TOUCH
			
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

static func get_required_lr(lvl, lvl_max = null):
	if(lvl_max):
		var lvl_diff = lvl_max - lvl
		var acc: int = 0
		
		for i in range(lvl + 1, lvl_max):
			print(i)
			acc += 600 + pow(2*i, 2)
		return acc
		
	return 600 + pow(2*lvl, 2)

func level_up(stat: Enums.STATS, amt):
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

func on_bodypart_selected(bodypart: SkillBodypart, stat):
	selected_bodypart = bodypart
	selected_stat = stat
