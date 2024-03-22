extends Node2D
class_name CombatSkillManager

const SKILL_DATA_LOCATION = "res://Resources/Custom/CombatSkills/"

var skills_data := [null, null]
var can_use_skill := [null, null]
@onready var skill_timers := [$Skill1Cooldown, $Skill2Cooldown]
@onready var player: CombatPlayer = get_parent()

func _ready():
	for i in PlayerStats.equipped_skills.size():
		var skill_name = PlayerStats.equipped_skills[i]
		can_use_skill[i] = skill_name != ""
		
		if !can_use_skill[i]:
			return
			
		skills_data[i] = ResourceLoader.load(SKILL_DATA_LOCATION + skill_name + ".tres")
		skill_timers[i].wait_time = skills_data[i].cooldown
		skill_timers[i].timeout.connect(on_skill_cooldown_timeout.bind(i))

func _unhandled_key_input(event):
	if event.is_action_pressed("combat_skill_1") && can_use_skill[0]:
		use_skill(0)
	elif event.is_action_pressed("combat_skill_2") && can_use_skill[1]:
		use_skill(1)

func use_skill(index: int):
	skill_timers[index].start()
	can_use_skill[index] = false
	
	match PlayerStats.equipped_skills[index]:
		"dash":
			player.dash_factor = 3
			player.dash_timer.start()

func on_skill_cooldown_timeout(index: int):
	can_use_skill[index] = true
