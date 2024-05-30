extends Item
class_name ItemDate

const HEAL_AMT = 20

func use(target):
	target.health = min(target.max_health, target.health + HEAL_AMT)

func is_usable(player: Player, enemies: Array[Node]) -> bool:
	return player.health < player.max_health
