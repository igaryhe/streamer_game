extends Node3D

@onready var score_manager: ScoreManager = SLocator.with(self).fetch(ScoreManager)
@onready var player_controller: PlayerController = SLocator.with(self).fetch(PlayerController)
@onready var open_area: OpenArea = SLocator.with(self).fetch(OpenArea)

@export var score_watch_value: float = 60
@export var anim_player: AnimationPlayer
@export var ghost: Node3D
@export var appear_length: float = 10
var is_started: bool = false


func _process(delta: float) -> void:
	if (!is_started
		&& score_manager.ghost_score >= score_watch_value
		&& open_area.is_player_inside):
		is_started = true
		set_node_in_front_of_player(player_controller, ghost, appear_length)
		anim_player.play("ghost_started")

	if (is_started && !anim_player.is_playing()):
		set_process(false)

func set_node_in_front_of_player(player: Node3D, target: Node3D, length: float) -> void:
	var camera: Camera3D = player.camera
	
	# 获取原始前方向并投影到XZ平面
	var raw_forward: Vector3 = - camera.global_transform.basis.z
	var horizontal_forward = Vector3(raw_forward.x, 0, raw_forward.z).normalized()
	
	# 处理垂直视角特殊情况（当摄像机完全朝上/下时）
	if horizontal_forward.length_squared() < 0.0001:
		# 回退到玩家节点的水平前方向
		var player_forward = player.global_transform.basis.z
		horizontal_forward = Vector3(player_forward.x, 0, player_forward.z).normalized()
	
	# 计算目标位置（保持与玩家相同Y轴高度）
	var target_position = Vector3(
		player.global_position.x + horizontal_forward.x * length,
		player.global_position.y,
		player.global_position.z + horizontal_forward.z * length
	)
	
	# 设置位置并保持水平朝向
	target.global_position = target_position
	target.look_at(target_position + horizontal_forward, Vector3.UP)
