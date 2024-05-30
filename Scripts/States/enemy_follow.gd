extends State

@export var attack_state: State
@export var attack_range: Area3D

func enter() -> void:
	pass

func process_physics(delta: float) -> State:
	if(!parent.in_combat):
		return null

	if (attack_range.get_overlapping_bodies().size() > 0 and parent.cdwn_timer.time_left <= 0):
		return attack_state
	
	if (attack_range.get_overlapping_bodies().size() == 0):
		var player: Player = get_tree().get_first_node_in_group("player")
		var direction := (player.global_position - parent.global_position).normalized()
		direction.y = 0
		MoveComponent.choose_anim(animations, direction)
		move_component.move(delta, direction)
	return null
