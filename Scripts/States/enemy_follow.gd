extends State

@export var attack_state: State
@export var attack_range: Area2D

func enter() -> void:
	pass

func process_physics(delta: float) -> State:
	if (attack_range.get_overlapping_bodies().size() > 0 and parent.cdwn_timer.time_left <= 0):
		return attack_state
	
	if (attack_range.get_overlapping_bodies().size() == 0):
		var direction := (player.global_position - parent.global_position).normalized()
		MoveComponent.choose_anim(animations, direction)
		move_component.move(delta, direction)
	return null
