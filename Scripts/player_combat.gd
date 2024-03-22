extends CharacterBody2D
class_name CombatPlayer

const SPEED = 1000

var dash_factor: float = 1
@onready var dash_timer : Timer = $DashTimer
var direction := Vector2.ZERO

func _ready():
	dash_timer.timeout.connect(on_dash_timer_timeout)

func _physics_process(delta):
	if dash_factor == 1:
		direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	
	if direction:
		if dash_factor > 1.0:
			
			var weight := dash_timer.time_left / dash_timer.wait_time
			var from := SPEED * direction
			var to := from * dash_factor
			velocity = Vector2(EasingFunctions.ease_out_sine(from.x, to.x, weight), EasingFunctions.ease_out_sine(from.y, to.y, weight))

		else:
			velocity = direction * SPEED

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

func on_dash_timer_timeout():
	dash_factor = 1
