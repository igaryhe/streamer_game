extends Interactable

@export var sfx: AudioStreamPlayer3D
@export var mesh: MeshInstance3D
@export var spawn_pos: Node3D
@export var nightcrawler: PackedScene
@export var drunk_nightcrawler: PackedScene
@export var apple_id: int

func interact(item_id: int):
	print("interacting with shrine")
	sfx.play()
	if item_id == apple_id:
		var scene = nightcrawler.instantiate()
		get_tree().root.add_child(scene)
		scene.global_position = spawn_pos.global_position
	else:
		var scene = drunk_nightcrawler.instantiate()
		get_tree().root.add_child(scene)
		scene.global_position = spawn_pos.global_position
