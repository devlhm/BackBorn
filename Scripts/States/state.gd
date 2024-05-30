class_name State
extends Node

@export var animation_name: String

var animations: AnimatedSprite3D
var parent: CharacterBody3D
var move_component: MoveComponent
#var player: CharacterBody3D

func enter() -> void:
	if animation_name:
		animations.play(animation_name)

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null
