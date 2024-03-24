extends Node

const SKILL_DATA_LOCATION = "res://Resources/Custom/CombatSkills/"
const ITEM_DATA_LOCATION = "res://Resources/Custom/Items/"
const QUICK_ITEM_DATA_LOCATION = "res://Resources/Custom/QuickItems/"

var stats = {
	"sight": 1,
	"smell": 1,
	"touch": 1,
	"hearing": 1,
	"taste": 1,
	"faith": 1
}

var inventory = [{"item": load_item("date"), "uses":0}, {"item": load_item("poison"), "uses": 0}]
var equipped_skills: Array[CombatSkill] = [load_combat_skill("dash"), null]
var equipped_quick_items: Array[QuickItem] = [load_quick_item("sword"), null]

func on_item_use(entry_index: int):
	var entry = inventory[entry_index]
	entry.uses += 1
	if entry.uses == entry.item.max_uses:
		inventory.remove_at(entry_index)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func load_item(item_name: String) -> Item:
	return ResourceLoader.load(ITEM_DATA_LOCATION + item_name + ".tres")

func load_combat_skill(skill_name: String) -> CombatSkill:
	return ResourceLoader.load(SKILL_DATA_LOCATION + skill_name + ".tres")

func load_quick_item(item_name: String) -> QuickItem:
	return ResourceLoader.load(QUICK_ITEM_DATA_LOCATION + item_name + ".tres")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
