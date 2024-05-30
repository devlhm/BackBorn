extends CharacterBody3D
class_name CombatEnemy

signal death(reward: float)

@onready var state_machine: StateMachine = $StateMachine

@export var lvl: int
@export var lp:  int
@export var atk_formula: String 
@export var cdwn: float
@export var reward_formula: String
@export var ai_type: Enums.AI_TYPE
@export var atk_range: Enums.ATTACK_RANGES
@export var enemy_name: String

@export var hurtbox: Area3D
@export var cdwn_timer: Timer

@onready var sprite = $Sprite

var in_combat: bool = false
var player: Player

func _ready():
	hurtbox.area_entered.connect(on_hurtbox_entered)
	state_machine.init(self, sprite, $MoveComponent)

	sprite.play("move_down")

func on_combat_start():
	in_combat = true
	cdwn_timer.wait_time = cdwn
	
func on_hurtbox_entered(hitbox: Area3D):
	lp -= hitbox.damage
	if lp == 0:
		die()

func die():
	var expression = Expression.new()
	expression.parse(reward_formula, ["spirit"])
	death.emit(expression.execute([PlayerStats.attributes.spirit]))

	queue_free()

func _physics_process(delta):
	state_machine.process_physics(delta)

func _process(delta):
	state_machine.process_frame(delta)