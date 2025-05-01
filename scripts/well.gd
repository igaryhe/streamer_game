class_name Well
extends Interactable
@export var sfx: AudioStreamPlayer3D
@export var mesh: MeshInstance3D
@export var blood_texture: Texture2D

func interact(item_id: int):
	sfx.play()
	(mesh.get_surface_override_material(0) as ShaderMaterial).set_shader_parameter("albedo", blood_texture)
	set_collision_layer_value(3, true)
