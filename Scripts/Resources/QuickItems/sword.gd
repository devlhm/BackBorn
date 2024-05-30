extends QuickItem
class_name QuickItemSword

@export var swordScene: PackedScene
const DMG = 10

var instance: Node3D

func on_combat_start(player: Player):
	instance = swordScene.instantiate()
	player.instance_at_hand(instance)
	

func use(target):
	instance.get_node("AnimationPlayer").play("attack")
