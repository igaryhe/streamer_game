extends Area3D

@export var crash_sfx: AudioStreamPlayer3D
@export var score_manager: ScoreManager
var trigger: bool = false

func _ready() -> void:
	monitoring = true

func _body_entered(body: Node3D):
	if trigger:
		return
	if body is PlayerController:
		trigger = true
		score_manager.anomaly_observed()
		crash_sfx.play()
