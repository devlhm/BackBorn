extends CombatAction
class_name CombatActionFear

@export var duration_turns: int = 1
@export var speed_amount: int = 500
var turns = 0
var player

func use(target):
	var player = target as CombatPlayer
	self.player = player
	player.speed += speed_amount
	
func on_expire():
	player.speed -= speed_amount

func on_turn_end():
	turns += 1
	player.speed -= speed_amount
	if duration_turns == turns:
		on_expire()
