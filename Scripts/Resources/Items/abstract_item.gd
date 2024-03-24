extends RefCounted
class_name AbstractItem

static func use(target):
	pass

static func is_usable(player: Player, enemies: Array[Node]) -> bool:
	return true
