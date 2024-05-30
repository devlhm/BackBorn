extends Node
class_name MoveComponent

@export var speed : float = 5
@export var stop_speed : float = 5
@export var dash_factor : float = 1
@onready var parent: PhysicsBody3D = get_parent()

var last_direction := Vector3.ZERO

func move(delta: float, direction: Vector3):
	if direction:
		last_direction = direction
		parent.velocity.x = direction.x * speed * delta
		parent.velocity.z = direction.z * speed * delta
	else:
		parent.velocity.x = move_toward(parent.velocity.x, 0, stop_speed * delta)
		parent.velocity.z = move_toward(parent.velocity.z, 0, stop_speed * delta)
		
	parent.move_and_slide()

static func choose_anim(animations: AnimatedSprite3D, direction: Vector3):
	var interval_amp = 360 as float / 8
	var direction_ang = rad_to_deg(Vector2(direction.x, direction.z).angle()) + 180
	var starting_point = interval_amp / 2

	var anim_name

	if(Helpers.is_in_range(direction_ang, starting_point, interval_amp + starting_point)):
		anim_name = "move_side_up"
		animations.flip_h = false
	elif Helpers.is_in_range(direction_ang, interval_amp + starting_point, (2 * interval_amp) + starting_point):
		anim_name = "move_up"
		animations.flip_h = false
	elif Helpers.is_in_range(direction_ang, (2 * interval_amp) + starting_point, (3 * interval_amp) + starting_point):
		anim_name = "move_side_up"
		animations.flip_h = true
	elif Helpers.is_in_range(direction_ang, (3 * interval_amp) + starting_point, (4 * interval_amp) + starting_point):
		anim_name = "move_side"
		animations.flip_h = false
	elif Helpers.is_in_range(direction_ang, (4 * interval_amp) + starting_point, (5 * interval_amp) + starting_point):
		anim_name = "move_side_down"
		animations.flip_h = false
	elif Helpers.is_in_range(direction_ang, (5 * interval_amp) + starting_point, (6 * interval_amp) + starting_point):
		anim_name = "move_down"
		animations.flip_h = false
	elif Helpers.is_in_range(direction_ang, (6 * interval_amp) + starting_point, (7 * interval_amp) + starting_point):
		anim_name = "move_side_down"
		animations.flip_h = true
	else:
		anim_name = "move_side"
		animations.flip_h = true

	if anim_name != animations.animation:
		#TODO DEIXAR MAIS FLUIDO DE ALGUMA FORMA
		var frame = animations.frame
		var fp = animations.frame_progress
		animations.animation = anim_name
		animations.set_frame_and_progress(frame, fp)
		
func dash(delta: float, weight: float, direction: Vector3 = Vector3.ZERO ):
	if direction == Vector3.ZERO:
		direction = last_direction
	
	var from := speed * direction * delta
	var to := from * dash_factor
	parent.velocity = Vector3(EasingFunctions.ease_out_sine(from.x, to.x, weight), 0, EasingFunctions.ease_out_sine(from.z, to.z, weight))
	parent.move_and_slide()