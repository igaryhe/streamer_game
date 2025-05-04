extends Area3D

var triggered: bool
@export var pre_jumpscare_sfx: AudioStreamPlayer

func _body_entered(body: Node3D):
	if triggered:
		return
	if body is PlayerController:
		triggered = true
		pre_jumpscare_sfx.play()
