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

var inventory: Array[Item] = [ResourceLoader.load(ITEM_DATA_LOCATION + "date.tres")]

var equipped_skills: Array[CombatSkill] = [ResourceLoader.load(SKILL_DATA_LOCATION + "dash.tres"), null]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
