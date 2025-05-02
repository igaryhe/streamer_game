extends Area3D

@export var sprite_anim: AnimatedSprite3D
@export var jump_scare_sfx: AudioStreamPlayer3D
@export var score_manager: ScoreManager
var triggered: bool

func _ready() -> void:
	monitoring = true
	
func _body_entered(body: Node3D):
	if triggered:
		return
	if body is PlayerController:
		sprite_anim.play("default")
		jump_scare_sfx.play()
		triggered = true
		score_manager.anomaly_observed()
	
