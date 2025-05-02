extends Node3D

@export var player: Node3D
@export var score_manager: ScoreManager
@export var observe_distance: float = 20
@export var shards: Array[VisibleOnScreenNotifier3D]
@export var meshes: Array[MeshInstance3D]
var last_visibility: Array[bool] = [false, false, false]

var visible_id: int
var observed: bool = false

func _ready():
	for mesh in meshes:
		mesh.visible = false
	visible_id = 2
	meshes[visible_id].visible = true
	last_visibility[visible_id] = true

func _process(delta: float):
	if last_visibility[visible_id] and !shards[visible_id].is_on_screen():
		for i in 3:
			if i == visible_id:
				continue
			if shards[i].is_on_screen():
				continue
			if (player.global_position - global_position).length() < observe_distance and !observed:
				score_manager.anomaly_observed()
				observed = true
				print("quantum shard anomaly observed")
			meshes[visible_id].visible = false
			meshes[i].visible = true
			visible_id = i
			break
	for i in 3:
		last_visibility[i] = shards[i].is_on_screen()
