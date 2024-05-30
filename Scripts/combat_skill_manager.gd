extends Node3D
class_name CombatSkillManager

var can_use_skill := [null, null]
@onready var skill_timers := [$Skill1Cooldown, $Skill2Cooldown]

func _ready():
	for i in PlayerStats.equipped_skills.size():
		can_use_skill[i] = PlayerStats.equipped_skills[i] != null
		
		if !can_use_skill[i]:
			return

		skill_timers[i].wait_time = PlayerStats.equipped_skills[i].cooldown
		skill_timers[i].timeout.connect(on_skill_cooldown_timeout.bind(i))

func _unhandled_key_input(event):
	if event.is_action_pressed("combat_skill_1") && can_use_skill[0]:
		use_skill(0)
	elif event.is_action_pressed("combat_skill_2") && can_use_skill[1]:
		use_skill(1)

func use_skill(index: int):
	skill_timers[index].start()
	can_use_skill[index] = false
	
	match (PlayerStats.equipped_skills[index] as CombatSkill).name:
		"_":
			pass

func on_skill_cooldown_timeout(index: int):
	can_use_skill[index] = true
