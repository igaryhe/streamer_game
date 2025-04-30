class_name Well
extends Interactable
@export var expected_item_id: int
@export var sfx: AudioStreamPlayer3D
@export var blood_texture: Texture2D
@export var mesh: MeshInstance3D

func interact(player, item_id: int):
	if item_id == expected_item_id:
		sfx.play()
		(mesh.get_surface_override_material(0) as ShaderMaterial).set_shader_parameter("albedo", blood_texture)
		player.holding_item = -1
