extends CharacterBody3D
class_name Player

const SPEED = 5
const STOP_SPEED = 5
var frozen = false

@onready var sprite: AnimatedSprite3D = $Sprite

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if frozen:
		return
		
	sprite.play()

	if Input.is_action_pressed("ui_up"):
		sprite.animation = "walk_up"
	elif Input.is_action_pressed("ui_left"):
		sprite.animation = "walk_left"
	elif Input.is_action_pressed("ui_right"):
		sprite.animation = "walk_right"
	elif Input.is_action_pressed("ui_down"):
		sprite.animation = "walk_down"
	else:
		sprite.stop()
		sprite.frame = 2

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, STOP_SPEED)
		velocity.z = move_toward(velocity.z, 0, STOP_SPEED)
	
	move_and_slide()

func freeze():
	frozen = true
	sprite.frame = 2
	sprite.stop()
	
func unfreeze():
	frozen = false
