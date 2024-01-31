extends CanvasLayer
class_name DialogComponent

signal dialog_start
signal dialog_end

const TEXT_SPEED = 0.05
@export_file() var first_dialog_path
@export_dir() var dialogs_dir
@export_dir() var dialog_sprites_dir
@export var text_container: VBoxContainer
@export var button_container: VBoxContainer
@export var right_char_texture: TextureRect
@export var next_indicator: TextureRect
@onready var label : RichTextLabel = text_container.get_node("Text")

var curr_dialog
var curr_block: Dictionary

var text_tween: Tween
var awaiting_choice: bool = false
var text_index : int = 0

@export var dialog_button_scene: PackedScene

func _input(event):
	if event.is_action_pressed("ui_accept") and !awaiting_choice:
		if text_tween.is_running():
			text_tween.stop()
			label.visible_ratio = 1
			show_next_indicator()
		else:
			next_text()

func _ready():
	set_process_input(false)
	# Parse dialogs at dir to dictionaries
	curr_dialog = JSONHelper.load_json(first_dialog_path)

func show_next_indicator():
	(next_indicator.get_node("AnimationPlayer") as AnimationPlayer).play("blink")

func hide_next_indicator():
	(next_indicator.get_node("AnimationPlayer") as AnimationPlayer).stop()
	next_indicator.hide()
	
func on_text_tween_finished():
	show_next_indicator()

func show_text():
	text_tween = create_tween()
	text_tween.finished.connect(on_text_tween_finished)
	label.visible_ratio = 0
	label.text = curr_block.text[text_index]
	text_tween.tween_property(label, "visible_ratio", 1, TEXT_SPEED * label.get_total_character_count())

func start():
	if !curr_dialog:
		return
	
	
	curr_block = curr_dialog.S1
	
	read_block()
	show()

	set_process_input(true)
	dialog_start.emit()

func next_text():
	hide_next_indicator()
	text_index += 1
	if text_index < curr_block.text.size():
		show_text()
	else:
		next_block()
	
func next_block():
	text_container.hide()
	button_container.hide()
	
	var next_block_id: String = curr_block.to
	if(next_block_id != "end"):
		curr_block = curr_dialog[next_block_id]
		read_block()
	else:
		end()

func read_block():
	text_index = 0
	awaiting_choice = false
	
	var sprite_path: String = curr_block.sprite
	
	if(sprite_path != "none"):
		right_char_texture.texture = load(dialog_sprites_dir + "/" + sprite_path + ".png")
	else:
		right_char_texture.texture = null
	
	if curr_block.type == "speech":
		text_container.show()
		(text_container.get_node("SpeakerName") as RichTextLabel).text = "[center]"+curr_block.name.to_upper()+"[/center]"
		show_text()
	else:
		awaiting_choice = true
		var options: Array = curr_block["options"]
		for i in options.size():
			var option: Dictionary = options[i]
			var instance: Button = dialog_button_scene.instantiate()
			instance.name = str(i)
			instance.text = option.text
			button_container.add_child(instance)
			instance.button_up.connect(on_choice_button_up.bind(option))
		button_container.show()

func on_choice_button_up(option_block: Dictionary):
	curr_block = option_block
	for button in button_container.get_children():
		button_container.remove_child(button)
		button.queue_free()
	next_block()

func end():
	set_process_input(false)
	hide()
	var next_dialog = curr_dialog.end.next
	
	if(next_dialog == "none"):
		curr_dialog = null
	elif(next_dialog != "self"):
		curr_dialog = JSONHelper.load_json(dialogs_dir + "/" + next_dialog + ".json")

	dialog_end.emit()
