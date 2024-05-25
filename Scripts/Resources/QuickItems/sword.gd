extends QuickItem
class_name QuickItemSword

@export var swordScene: PackedScene
const DMG = 10

var instance: Node2D

func on_combat_start(player: CombatPlayer):
	instance = swordScene.instantiate()
	player.get_node("Hand").add_child(instance)

func use(target):
	instance.get_node("AnimationPlayer").play("attack")
