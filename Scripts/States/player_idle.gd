extends State

@export var move_state: State
@export var attack_state: State

func enter() -> void:
	super()

func process_input(event: InputEvent) -> State:
	if Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down").normalized() != Vector2.ZERO:
		return move_state
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null
