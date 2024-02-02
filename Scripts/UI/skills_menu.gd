extends Node2D

@export var cam_transition_time: float = 1

@export var main_camera: Camera2D
@export var head_camera: Camera2D
@export var hand_camera: Camera2D

var init_camera_zoom: Vector2
var init_camera_pos: Vector2
var selected_bodypart := false

# Called when the node enters the scene tree for the first time.
func _ready():
	init_camera_zoom = main_camera.zoom
	init_camera_pos = main_camera.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if selected_bodypart:
			get_tree().call_group("ring", "show")	
			zoom_to(main_camera, init_camera_pos, init_camera_zoom)

func _on_click_area_input_event(viewport, event, shape_idx, id):
	if (event is InputEventMouseButton && event.pressed):
		event = event as InputEventMouseButton
		
		bodypart_selected(id)

func bodypart_selected(id: String):
	get_tree().call_group("ring", "hide")
	#main_camera.enabled = false
	
	var selected_camera: Camera2D
	
	if(id == "head"):
		selected_camera = head_camera
		#head_camera.enabled = true
	elif(id == "hand"):
		selected_camera = hand_camera
		#hand_camera.enabled = true
	
	selected_bodypart = true
	zoom_to(init_camera_pos, selected_camera.global_position,selected_camera.zoom)

func zoom_to(camera, pos, zoom):
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(main_camera, "global_position", pos, cam_transition_time)
	tween.tween_property(main_camera, "zoom", zoom, cam_transition_time)
	
