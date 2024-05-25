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
	var direction = Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down").normalized()
	
	if(direction == Vector2.ZERO):
		return idle_state
		
	move_component.move(delta, direction)
	return null
