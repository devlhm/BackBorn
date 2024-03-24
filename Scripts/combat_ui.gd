extends CanvasLayer
class_name CombatUI

@export var turn_cooldown: Timer
@export var turn_indicator: TextureRect
@export var combat_submenu_btn_scn: PackedScene
@export var btn_container: GridContainer
var player: CombatPlayer

@export var turn_menu_anim: AnimationPlayer
var submenu_selected := false

func _process(delta):
	turn_indicator.material.set_shader_parameter("progress", 1 - (turn_cooldown.time_left / turn_cooldown.wait_time))

func _input(event):
	if event.is_action_pressed("ui_cancel") and submenu_selected:
		on_submenu_exit()

func on_turn_start():
	turn_menu_anim.play("show")
	
func on_turn_end():
	turn_menu_anim.play_backwards("show")

func _on_submenu_button_up(button_name: String):
	print("button_name")
	submenu_selected = true

	match(button_name):
		"item":
			on_item_submenu()

	turn_menu_anim.play("show_2")

func on_submenu_exit():
	turn_menu_anim.play("hide_2")
	submenu_selected = false

func on_combat_submenu():
	pass
	
func on_empathy_submenu():
	pass
	
func render_btn(title: String, desc: String, icon: Texture2D, enabled: bool, click_callback: Callable):
		
		var btn: Button = combat_submenu_btn_scn.instantiate()
		(btn.get_node("MarginContainer/HboxContainer/HBoxContainer/CellTitle") as Label).text = title
		(btn.get_node("MarginContainer/HboxContainer/VBoxContainer/CellDesc") as RichTextLabel).text = desc
		(btn.get_node("MarginContainer/HboxContainer/Icon") as TextureRect).texture = icon
		btn.button_up.connect(click_callback)
		btn_container.add_child(btn)

func target_selector():
	#TODO
	return get_tree().get_nodes_in_group("enemy") #PLACEHOLDER

func select_target(target_type: Enums.COMBAT_TARGET, target_amt: int):
	match target_type:
		Enums.COMBAT_TARGET.PLAYER:
			return get_tree().get_first_node_in_group("player")
		Enums.COMBAT_TARGET.ALL_ENEMIES:
			return get_tree().get_nodes_in_group("enemy")
		Enums.COMBAT_TARGET.ENEMY:
			var enemies := get_tree().get_nodes_in_group("enemy")
			if(enemies.size() <= target_amt):
				return enemies
			return target_selector()
	
func on_item_submenu():
	for item in PlayerStats.inventory:
		item = item as Item
		var item_target = select_target(item.target, item.target_amount)
		var item_usable := item.is_usable(get_tree().get_first_node_in_group("player"), get_tree().get_nodes_in_group("enemy"))
		render_btn(item.display_name, item.description, item.icon, item_usable, item.use.bind(item_target))
