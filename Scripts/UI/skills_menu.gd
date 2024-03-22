extends Node2D

@export var cam_transition_time: float
@export var main_camera: Camera2D
@export var head_camera: Camera2D
@export var hand_camera: Camera2D

var init_camera_zoom: Vector2
var init_camera_pos: Vector2
var selected_bodypart := false
var zooming := false
func _ready():
	init_camera_zoom = main_camera.zoom
	init_camera_pos = main_camera.global_position
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if selected_bodypart:
			if(zooming):
				return
		
			get_tree().call_group("ring", "show")
			zoom_to(main_camera, init_camera_pos, init_camera_zoom)

func _on_click_area_input_event(viewport, event, shape_idx, id):
	if (event is InputEventMouseButton && event.pressed):
		if(zooming):
			return
		
		bodypart_selected(id)

func bodypart_selected(id: String):
	get_tree().call_group("ring", "hide")

	var selected_camera: Camera2D

	if(id == "head"):
		selected_camera = head_camera
	elif(id == "hand"):
		selected_camera = hand_camera

	selected_bodypart = true
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
