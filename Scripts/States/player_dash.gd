extends State

@export var move_state: State
@export var dash_timer: Timer
@export var dash_cooldown: Timer

func enter() -> void:
	super()
	dash_timer.start()

func exit() -> void:
	dash_cooldown.start()

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	var weight: float = dash_timer.time_left / dash_timer.wait_time
	move_component.dash(delta, weight)

	if dash_timer.time_left <= 0:
		return move_state

	return null
