extends Node3D

@export var sprite: Sprite3D
@export var collider: StaticBody3D
@export var interval: float
@export var visible_duration: float
@export var transform_duration: float
@export var initial_delay: float

var timer: float
# 0 for hiding
# 1 for showing
# 2 for transforming from hiding to showing
# 3 for transforming from showing to hiding
var state: int

func _ready() -> void:
	timer = visible_duration + initial_delay
	state = 1

func _process(delta: float):
	timer -= delta
	if state == 2:
		sprite.modulate.a = 1 - (timer / transform_duration)
		if timer <= 0:
			state = 1
			timer = visible_duration
	elif state == 3:
		sprite.modulate.a = timer / transform_duration
		if timer <= 0:
			state = 0
			timer = interval
	elif state == 0:
		sprite.modulate.a = 0
		collider.process_mode = Node.PROCESS_MODE_DISABLED
		if timer <= 0:
			state = 2
			timer = transform_duration
	elif state == 1:
		sprite.modulate.a = 1
		collider.process_mode = Node.PROCESS_MODE_INHERIT
		collider.visible = true
		if timer <= 0:
			state = 3
			timer = transform_duration
