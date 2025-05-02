extends Interactable

@export var sfx: AudioStreamPlayer3D
@export var mesh: MeshInstance3D

func interact(item_id: int):
	sfx.play()
	mesh.visible = false
	set_collision_layer_value(1, false)
	set_collision_layer_value(2, false)
