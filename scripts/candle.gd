extends Interactable

@export var ambient: AudioStreamPlayer3D
@export var sfx: AudioStreamPlayer3D
@export var lights: Array[OmniLight3D]
@export var doll_spawn_pos: Node3D
@export var doll_prefab: PackedScene

func interact(item_id: int):
	ambient.stop()
	sfx.play()
	for light in lights:
		light.visible = false
	var scene = doll_prefab.instantiate()
	doll_spawn_pos.add_child(scene)
	(scene as Node3D).position = Vector3(0.0, 0.0, 0.0)
	(scene as Item).id = 5
	(scene as Item).setup()
