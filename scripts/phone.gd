extends Interactable

@export var ring_sfx: AudioStreamPlayer3D
@export var jump_scare_sfx: AudioStreamPlayer3D

func interact(item_id: int):
	ring_sfx.stop()
	jump_scare_sfx.play()
	set_collision_layer_value(2, false)
