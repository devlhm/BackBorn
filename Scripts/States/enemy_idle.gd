extends State

@export var follow_state: State

func enter() -> void:
	super()

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	await get_tree().create_timer(1).timeout
	return follow_state

func process_physics(delta: float) -> State:
	return null
