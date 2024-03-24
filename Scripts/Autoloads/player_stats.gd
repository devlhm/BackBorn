extends Node

const SKILL_DATA_LOCATION = "res://Resources/Custom/CombatSkills/"
const ITEM_DATA_LOCATION = "res://Resources/Custom/Items/"
var stats = {
	"sight": 1,
	"smell": 1,
	"touch": 1,
	"hearing": 1,
	"taste": 1,
	"faith": 1
}

var inventory: Array[Item] = [load_item("date"), load_item("poison")]

var equipped_skills: Array[CombatSkill] = [load_combat_skill("dash"), null]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func load_item(item_name: String) -> Item:
	return ResourceLoader.load(ITEM_DATA_LOCATION + item_name + ".tres")

func load_combat_skill(skill_name: String) -> CombatSkill:
	return ResourceLoader.load(SKILL_DATA_LOCATION + skill_name + ".tres")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
