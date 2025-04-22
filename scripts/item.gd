extends Node3D
@onready var mesh = $mesh
@onready var collider = $StaticBody3D

const interact_signal = "on_interact"

func _ready():
	print(collider)
	var tween = get_tree().create_tween()
	tween.tween_property(mesh, "position", Vector3(0, 0.8, 0), 1).set_trans(Tween.TRANS_SINE)
	tween.tween_property(mesh, "position", Vector3(0, 1, 0), 1).set_trans(Tween.TRANS_SINE)
	tween.set_loops()

func _on_interact():
	print("receiving signal")
