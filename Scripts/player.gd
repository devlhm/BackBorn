extends CharacterBody3D
class_name Player

signal health_changed(new_health: int)

var frozen = false

var max_health = 400 + (PlayerStats.attributes.vigor * 24)
var health = max_health:
	set(value):
		health = value
		health_changed.emit(value, max_health)

@onready var state_machine: StateMachine = $StateMachine
@onready var move_component: MoveComponent = $MoveComponent
@onready var sprite: AnimatedSprite3D = $Sprite
@onready var hand: Marker3D = $Hand

func _ready():
	state_machine.init(self, sprite, move_component)
	sprite.play("move_down")

func _physics_process(delta):
	if frozen:
		return
	
	state_machine.process_physics(delta)

func _input(event):
	state_machine.process_input(event)

func instance_at_hand(instance):
	for child in hand.get_children():
		hand.remove_child(child)
		child.queue_free()

	hand.add_child(instance)

func damage(amt: int):
	print("ouch!")
	#health -= amt

func on_enemy_death(reward: int):
	var heal_amt = min(reward, max_health - health)
	reward -= heal_amt
	health += heal_amt
	if reward > 0:
		PlayerStats.increase_lr(reward)

func freeze():
	frozen = true
	sprite.frame = 2
	sprite.stop()
	
func unfreeze():
	frozen = false
