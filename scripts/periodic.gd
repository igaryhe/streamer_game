extends Node

@export var objects_to_show: Array[Node3D]
@export var animation: AnimationPlayer
@export var sfx: AudioStreamPlayer3D
@export var interval: float
@export var show_duration: float

var timer: float = 0

func _process(delta: float):
	var old_timer = timer
	timer -= delta
	if timer <= 0:
		timer += interval
	if timer > interval - show_duration:
		for obj in objects_to_show:
			obj.visible = true
	else:
		for obj in objects_to_show:
			obj.visible = false
