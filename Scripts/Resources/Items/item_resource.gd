extends Resource
class_name Item

@export var target: Enums.COMBAT_TARGET
@export var target_amount: int
@export var target_amount_exact: bool
@export var name: String
@export var display_name: String
@export var description: String
@export var icon: Texture2D

func use(target):
	pass

func is_usable(player: CombatPlayer, enemies: Array[Node]) -> bool:
	return true
