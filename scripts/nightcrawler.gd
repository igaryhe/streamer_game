class_name	Nightcrawler
extends Node3D

@export var hold_duration: float
@export var hide_duration: float
@export var anim: AnimatedSprite3D
@export var speed: float
@export var raycast: RayCast3D

var runtime_speed: float = 0
var passed_duration: float = 0
var destination: Node3D

func _ready() -> void:
	anim.play("default")

func _process(delta: float) -> void:
	if destination == null:
		return
	passed_duration	+= delta
	if passed_duration >= hold_duration:
		runtime_speed = speed
	if passed_duration >= hide_duration:
		anim.modulate.a = clamp(1 - (passed_duration - hide_duration), 0, 1)
	var dir: Vector3 = (destination.global_position - global_position).normalized()
	global_position += dir * runtime_speed * delta
	if raycast.is_colliding():
		var point = raycast.get_collision_point()
		position.y = point.y
