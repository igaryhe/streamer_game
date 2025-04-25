extends Node

@export var range: Vector2
@export var mesh: MeshInstance3D
@export var player: Node3D

func _process(delta: float):
	var distance = (player.global_position - mesh.global_position).length()
	var mat = (mesh.get_surface_override_material(0) as StandardMaterial3D)
	mat.albedo_color.a = (clampf(distance, range.x, range.y) - range.x) / (range.y - range.x)
