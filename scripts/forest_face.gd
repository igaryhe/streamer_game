extends Node3D

@export var range: Vector2
@export var sprite: SpriteBase3D
@export var player: Node3D
@export var collider: StaticBody3D

func _ready() -> void:
	collider.process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta: float):
	var distance = (player.global_position - sprite.global_position).length()
	sprite.modulate.a = (clampf(distance, range.x, range.y) - range.x) / (range.y - range.x)
	if sprite.modulate.a == 0:
		collider.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		collider.process_mode = Node.PROCESS_MODE_DISABLED
