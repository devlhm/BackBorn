extends State

@export var dash_state: State
@export var attack_state: State
@export var idle_state: State
@export var dash_cooldown: Timer

func enter() -> void:
	super()

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	if event.is_action_pressed("combat_skill_1"):
		if dash_cooldown.time_left <= 0:
			return dash_state
		
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	var input_dir = Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	
	if(direction == Vector3.ZERO):
		return idle_state
		
	MoveComponent.choose_anim(animations, direction)
	move_component.move(delta, direction)
	return null
