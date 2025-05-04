class_name Well
extends Interactable
@export var sfx: AudioStreamPlayer3D
@export var mesh: MeshInstance3D
@export var blood_texture: Texture2D
@export var door_anim_player: AnimationPlayer
@export var door_open_anim: String
@export var door_open_sfx: AudioStreamPlayer

func interact(item_id: int):
	sfx.play()
	(mesh.get_surface_override_material(0) as ShaderMaterial).set_shader_parameter("albedo", blood_texture)
	set_collision_layer_value(3, true)
	door_anim_player.play(door_open_anim)
	door_open_sfx.play()
