extends Node3D
@export var hold_duration: float
@export var anim: AnimatedSprite3D
@export var destination: Node3D
@export var speed: float
@export var raycast: RayCast3D

var runtime_speed: float = 0
var passed_duration: float = 0

func _ready() -> void:
	anim.play("default")

func _process(delta: float) -> void:
	passed_duration	+= delta
	if passed_duration >= hold_duration:
		runtime_speed = speed
	var dir: Vector3 = (destination.position - position).normalized()
	position += dir * runtime_speed * delta
	if raycast.is_colliding():
		var point = raycast.get_collision_point()
		position.y = point.y
