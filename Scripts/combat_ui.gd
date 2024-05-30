extends CanvasLayer
class_name CombatUI

signal turn_ended
signal targets_selected

@export var turn_indicator: TextureRect
@export var combat_submenu_btn_scn: PackedScene
@export var btn_container: GridContainer
@export var enemy_name_btn_scene: PackedScene
@export var health_bar: ProgressBar

@export var turn_menu_anim: AnimationPlayer
var submenu_selected := false

func on_combat_start():
	update_turn_indicator(0)
	health_bar.value = 100

	turn_indicator.show()

func on_combat_end():
	turn_indicator.hide()

func update_turn_indicator(progress):
	turn_indicator.material.set_shader_parameter("progress", progress)

func _input(event):
	if event.is_action_pressed("ui_cancel") && submenu_selected && !turn_menu_anim.is_playing():
		on_submenu_exit()
		
func on_plr_health_changed(new_health: int, max_health: int):
	health_bar.value = ( new_health as float / max_health as float ) * 100

func on_turn_start():
	turn_menu_anim.play("show")
	
func on_turn_end():
	if(!submenu_selected):
		turn_menu_anim.play_backwards("show")
	else:
		submenu_selected = false
		turn_menu_anim.play("hide_3")
		turn_menu_anim.animation_finished.connect(func(_anim): clean_btn_container(), CONNECT_ONE_SHOT)
		

func _on_submenu_button_up(button_name: String):
	if turn_menu_anim.is_playing(): return
	submenu_selected = true

	match(button_name):
		"item":
			on_item_submenu()
		"combat":
			on_combat_submenu()

	turn_menu_anim.play("show_2")

func render_btn(title: String, desc: String, icon: Texture2D, enabled: bool, click_callback: Callable):

		var btn: Button = combat_submenu_btn_scn.instantiate()
		(btn.get_node("MarginContainer/HBoxContainer/VBoxContainer/CellTitle") as Label).text = title
		(btn.get_node("MarginContainer/HBoxContainer/VBoxContainer/CellDesc") as RichTextLabel).text = desc
		(btn.get_node("MarginContainer/HBoxContainer/Icon") as TextureRect).texture = icon

		btn.button_up.connect(func():
			if turn_menu_anim.is_playing(): return
			await click_callback.call()
			turn_ended.emit()
			on_turn_end()
		)

		btn.disabled = !enabled
		btn_container.add_child(btn)

func clean_btn_container():
	for child in btn_container.get_children():
		btn_container.remove_child(child)
		child.queue_free()

func on_combat_submenu():
	for combat_action in PlayerStats.unlocked_combat_actions:
		render_btn(combat_action.display_name, combat_action.description, combat_action.icon, true, func(): 
			var target = await select_target(combat_action.target, combat_action.target_amount)
			combat_action.use(target)
		)

func on_empathy_submenu():
	pass

func on_item_submenu():
	for i in PlayerStats.inventory.size():
		var entry = PlayerStats.inventory[i]
		var item: Item = entry.item
		var item_usable : bool = item.is_usable(get_tree().get_first_node_in_group("player"), get_tree().get_nodes_in_group("enemy"))
		render_btn(item.display_name, item.description, item.icon, item_usable, func(): 
			var item_target = await select_target(item.target, item.target_amount)
			item.use(item_target)
			PlayerStats.on_item_use(i)
		)
	
func on_submenu_exit():
	
	turn_menu_anim.play("hide_2")
	turn_menu_anim.animation_finished.connect(func(anim): clean_btn_container(), CONNECT_ONE_SHOT)
	submenu_selected = false

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

			var enemies_selected = []
			target_selector(enemies_selected, target_amt)
			await targets_selected
			return enemies_selected

func target_selector(enemies_selected, target_amt: int):
	clean_btn_container()
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	for i in enemies.size():
		var enemy: Node = enemies[i]
		
		var enemy_name_btn: RichTextLabel = enemy_name_btn_scene.instantiate()
		enemy_name_btn.text = enemy.name
		btn_container.add_child(enemy_name_btn)
		
		var on_mouse_entered = func():
			enemy.modulate = Color.YELLOW
			enemy_name_btn.add_theme_color_override("default_color", Color.YELLOW)
		
		enemy_name_btn.mouse_entered.connect(on_mouse_entered)
		
		var on_mouse_exited = func():
			enemy.modulate = Color.WHITE
			enemy_name_btn.add_theme_color_override("default_color", Color.WHITE)
			
		enemy_name_btn.mouse_exited.connect(on_mouse_exited)
		
		enemy_name_btn.gui_input.connect(func(event: InputEvent):
			if event is InputEventMouseButton:
				event = event as InputEventMouseButton
				
				if event.pressed && event.button_index == MOUSE_BUTTON_LEFT && enemies_selected.find(enemy) == -1:
					enemies_selected.push_back(enemy)
					
					enemy_name_btn.mouse_exited.disconnect(on_mouse_exited)
					enemy_name_btn.mouse_entered.disconnect(on_mouse_entered)
					
					if(enemies_selected.size() == target_amt):
						targets_selected.emit(enemies_selected)
						on_targets_selected(enemies_selected)
		)
		
func on_targets_selected(targets):
	for target in targets:
		target.modulate = Color.WHITE
