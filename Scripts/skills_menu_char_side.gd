extends SubViewportContainer

@export var cam_transition_time: float
@export var main_camera: Camera2D
@export var head_camera: Camera2D
@export var hand_camera: Camera2D
@export var head_ring: Sprite2D
@export var hand_ring: Sprite2D

var selected_camera: Camera2D
var zooming := false
var zoomed := false
var init_camera_zoom: Vector2
var init_camera_pos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	init_camera_zoom = main_camera.zoom
	init_camera_pos = main_camera.global_position

func on_cancel():
	hand_ring.show()
	head_ring.show()
	
	if selected_camera == head_camera:
		for part in get_tree().get_nodes_in_group("head_part"):
			part.process_mode = Node.PROCESS_MODE_DISABLED
	
	selected_camera = null
	zoom_to(main_camera, init_camera_pos, init_camera_zoom)
	
func cam_selected(id: String):
	hand_ring.hide()
	head_ring.hide()
	
	match(id):
		"head":
			selected_camera = head_camera
			for part in get_tree().get_nodes_in_group("head_part"):
				part.process_mode = Node.PROCESS_MODE_INHERIT
		"hand":
			
			selected_camera = hand_camera
			
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

func _on_click_area_input_event(viewport, event, shape_idx, id):
	if event is InputEventMouseButton && event.pressed:
		if zooming:
			return

		cam_selected(id)
