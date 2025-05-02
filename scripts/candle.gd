extends Interactable

@export var ambient: AudioStreamPlayer3D
@export var sfx: AudioStreamPlayer3D
@export var lights: Array[OmniLight3D]
@export var doll: Node3D

func interact(item_id: int):
	ambient.stop()
	sfx.play()
	for light in lights:
		light.visible = false
	doll.visible = true
