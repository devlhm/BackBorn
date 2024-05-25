extends Resource
class_name CombatUsable

@export var name: String
@export var display_name: String
@export var description: String
@export var icon: Texture2D

func use(target):
	assert(false, name + " use function not implemented")
