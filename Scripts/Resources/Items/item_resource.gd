extends CombatUsable
class_name Item

@export var max_uses: int = 1
@export var target: Enums.COMBAT_TARGET
@export var target_amount: int
@export var target_amount_exact: bool

func use(target):
	assert(false, name + "use function not implemented")

func is_usable(player: CombatPlayer, enemies: Array[Node]) -> bool:
	if(target_amount_exact && target == Enums.COMBAT_TARGET.ENEMY && enemies.size() < target_amount):
		return false
	
	return true
