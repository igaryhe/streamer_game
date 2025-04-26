extends Node

@export var shards: Array[VisibleOnScreenNotifier3D]
@export var meshes: Array[MeshInstance3D]
@export var last_visibility: Array[bool] = [false, false, false]

var visible_id: int

func _ready():
	for mesh in meshes:
		mesh.visible = false
	visible_id = randi_range(0, 2)
	meshes[visible_id].visible = true
	last_visibility[visible_id] = true

func _process(delta: float):
	var last_position: int = -1
	var try_leaving: bool = false
	if last_visibility[visible_id] and !shards[visible_id].is_on_screen():
		try_leaving = true
	if try_leaving:
		for i in 3:
			if !shards[i].is_on_screen() and i != visible_id:
				meshes[visible_id].visible = false
				print("enabling")
				meshes[i].visible = true
				visible_id = i
				break
	for i in 3:
		last_visibility[i] = shards[i].is_on_screen()
