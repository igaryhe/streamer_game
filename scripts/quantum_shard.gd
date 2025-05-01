extends Node

@export var shards: Array[VisibleOnScreenNotifier3D]
@export var meshes: Array[MeshInstance3D]
var last_visibility: Array[bool] = [false, false, false]

var visible_id: int

func _ready():
	for mesh in meshes:
		mesh.visible = false
	visible_id = 2
	meshes[visible_id].visible = true
	last_visibility[visible_id] = true

func _process(delta: float):
	if last_visibility[visible_id] and !shards[visible_id].is_on_screen():
		for i in 3:
			if i == visible_id:
				continue
			if shards[i].is_on_screen():
				continue
			print("enabling " + str(i))
			meshes[visible_id].visible = false
			meshes[i].visible = true
			visible_id = i
			break
	for i in 3:
		last_visibility[i] = shards[i].is_on_screen()
