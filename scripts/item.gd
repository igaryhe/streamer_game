class_name Item extends Node3D
@onready var mesh: MeshInstance3D = $mesh
@onready var collider = $collider
@export var items: Items
@export var id: int

func setup():
	(mesh.get_surface_override_material(0) as StandardMaterial3D).albedo_texture = items.items[id].texture

func _ready():
	setup()
	var tween = get_tree().create_tween()
	tween.tween_property(mesh, "position", Vector3(0, 0.8, 0), 1).set_trans(Tween.TRANS_SINE)
	tween.tween_property(mesh, "position", Vector3(0, 1, 0), 1).set_trans(Tween.TRANS_SINE)
	tween.set_loops()

func _on_interact():
	print("receiving signal")
