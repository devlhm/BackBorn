extends Camera3D

@export var smoothSpeed: int
@onready var player = get_tree().get_first_node_in_group("player") as CharacterBody3D
var playerOffset: Vector3
# Called when the node enters the scene tree for the first time.
func _ready():
	playerOffset = position - player.position
	look_at(player.position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var new_pos = player.position + playerOffset
	position = lerp(position, new_pos, delta * smoothSpeed)
	
	for node in get_tree().get_nodes_in_group("billboard"):
		print("achei")
		node = node as Node3D
		node.look_at(Vector3(position.x, node.position.y, position.z))
