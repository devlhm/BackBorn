extends Node

const CUSTOM_RESOURCE_LOCATION = "res://Resources/Custom/"

const SKILL_DATA_LOCATION = CUSTOM_RESOURCE_LOCATION + "CombatSkills/"
const ITEM_DATA_LOCATION = CUSTOM_RESOURCE_LOCATION + "Items/"
const QUICK_ITEM_DATA_LOCATION = CUSTOM_RESOURCE_LOCATION + "QuickItems/"
const COMBAT_ACTION_DATA_LOCATION =  CUSTOM_RESOURCE_LOCATION + "CombatActions/"

var stats = {
	Enums.STATS.SIGHT: 1,
	Enums.STATS.SMELL: 1,
	Enums.STATS.TOUCH: 1,
	Enums.STATS.HEARING: 1,
	Enums.STATS.TASTE: 1,
	Enums.STATS.FAITH: 1
}

var attributes = {
	"vigor": 0,
	"stamina": 0,
	"const": 0,
	"strength": 0,
	"int": 0,
	"spirit": 0,
	"char": 0
}

var lvl: int = 1
var lr: int = 0
var inventory = [{"item": load_item("date"), "uses":0}, {"item": load_item("poison"), "uses": 0}]
var equipped_skills: Array[CombatSkill] = [load_combat_skill("dash"), null]
var equipped_quick_items: Array[QuickItem] = [load_quick_item("sword"), null]
var unlocked_combat_actions: Array[CombatAction] = [load_combat_action("fear")]

func increase_attr(attr_name: String, amt: int):
	attributes[attr_name] += amt

func on_item_use(entry_index: int):
	var entry = inventory[entry_index]
	entry.uses += 1
	if entry.uses == entry.item.max_uses:
		inventory.remove_at(entry_index)

func increase_lr(amt: int):
	lr += amt

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func load_item(item_name: String) -> Item:
	return ResourceLoader.load(ITEM_DATA_LOCATION + item_name + ".tres")

func load_combat_skill(skill_name: String) -> CombatSkill:
	return ResourceLoader.load(SKILL_DATA_LOCATION + skill_name + ".tres")

func load_quick_item(item_name: String) -> QuickItem:
	return ResourceLoader.load(QUICK_ITEM_DATA_LOCATION + item_name + ".tres")

func load_combat_action(item_name: String) -> CombatAction:
	return ResourceLoader.load(COMBAT_ACTION_DATA_LOCATION + item_name + ".tres")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
