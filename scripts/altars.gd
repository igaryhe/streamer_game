extends Node3D
@export var score_manager: ScoreManager
@export var lights: Array[OmniLight3D]

var current_level: int

func _process(delta: float) -> void:
	if current_level < score_manager.current_ghosting_level:
		for i in range(current_level, score_manager.current_ghosting_level):
			lights[i].visible = true
