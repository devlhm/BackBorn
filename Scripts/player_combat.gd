extends CharacterBody2D
class_name CombatPlayer

signal health_changed(new_health: int)

var speed := 1000
var max_health = 400 + (PlayerStats.attributes.vigor * 24)
var health = max_health:
	set(value):
		health = value
		health_changed.emit(value)

@onready var state_machine: StateMachine = $StateMachine
@onready var move_component: MoveComponent = $MoveComponent

func _ready():
	state_machine.init(self, $Sprite, move_component)

func _physics_process(delta):
	state_machine.process_physics(delta)

func _input(event):
	state_machine.process_input(event)

func damage(amt: int):
	print("ouch!")
	#health -= amt

func on_enemy_death(reward: int):
	#TODO verificar a cura e lr
	var heal_amt = min(reward, max_health - health)
	reward -= heal_amt
	health += heal_amt
	if reward > 0:
		PlayerStats.increase_lr(reward)
