extends CanvasLayer
class_name CombatUI

@export var turn_cooldown: Timer
@export var turn_indicator: TextureRect

@export var turn_menu_anim: AnimationPlayer

func _process(delta):
	turn_indicator.material.set_shader_parameter("progress", 1 - (turn_cooldown.time_left / turn_cooldown.wait_time))

func on_turn_start():
	turn_menu_anim.play("show")
	
func on_turn_end():
	turn_menu_anim.play_backwards("show")
