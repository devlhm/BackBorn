extends State

@export var delay: float = .3
@export var follow_state: State

func enter() -> void:
	var expression = Expression.new()
	expression.parse(parent.atk_formula, ["spirit"])
	var atk = expression.execute([PlayerStats.attributes.spirit])
	player.damage(atk)
	parent.cdwn_timer.start()
	super()

func process_frame(delta: float) -> State:
	#if parent.cdwn_timer.time_left <= 0:
	#	return follow_state
	
	return follow_state
