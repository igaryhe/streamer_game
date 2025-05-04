extends Node3D

@onready var score_manager: ScoreManager = SLocator.with(self).fetch(ScoreManager)
@onready var player_controller: PlayerController = SLocator.with(self).fetch(PlayerController)
@onready var open_area: OpenArea = SLocator.with(self).fetch(OpenArea)
@onready var game_state: GameStates = SLocator.with(self).fetch(GameStates)

@export var score_watch_value: float = 60
@export var anim_player: AnimationPlayer
@export var ghost: Node3D
@export var appear_offset: Vector3 = Vector3(0, 0, 8)
var move_toward_player: bool = false
@export var move_toward_player_duration: float = 1
@export var move_to_offset = Vector3.ZERO
var is_started: bool = false

var time_elapsed: float = 0


func _process(delta: float) -> void:
	if (!is_started
		&& score_manager.ghost_score >= score_watch_value
		&& open_area.is_player_inside):
		is_started = true
		anim_player.play("ghost_started")

	if (is_started && move_toward_player):
		time_elapsed += delta
		var remaining_time = move_toward_player_duration - time_elapsed
		var target_position = player_controller.global_position + move_to_offset
		
		var distance = ghost.global_position.distance_to(target_position)
		if distance > 0 and remaining_time > 0:
			var speed = distance / remaining_time
			var direction = (target_position - ghost.global_position).normalized()
			ghost.global_position += direction * speed * delta
	if (is_started && !anim_player.is_playing()):
		set_process(false)


func _teleport_ghost() -> void:
	set_node_in_front_of_player(player_controller, ghost, appear_offset)
	score_manager.anomaly_observed()

func _move_toward() -> void:
	time_elapsed = 0
	move_toward_player = true

func set_node_in_front_of_player(player: Node3D, target: Node3D, offset: Vector3) -> void:
	var camera: Camera3D = player.camera
	
	# 获取原始前方向并投影到XZ平面
	var raw_forward: Vector3 = - camera.global_transform.basis.z
	var horizontal_forward = Vector3(raw_forward.x, 0, raw_forward.z).normalized()
	
	# 处理垂直视角特殊情况（当摄像机完全朝上/下时）
	if horizontal_forward.length_squared() < 0.0001:
		# 回退到玩家节点的水平前方向
		var player_forward = player.global_transform.basis.z
		horizontal_forward = Vector3(player_forward.x, 0, player_forward.z).normalized()
	
	# 计算水平右方向
	var horizontal_right = horizontal_forward.cross(Vector3.UP).normalized()
	
	# 计算三维偏移量
	var displacement = horizontal_forward * offset.z + horizontal_right * offset.x + Vector3.UP * offset.y
	
	# 计算最终目标位置
	var target_position = player.global_position + displacement
	
	# 设置位置并保持水平朝向
	target.global_position = target_position
	target.look_at(target_position + horizontal_forward, Vector3.UP)

func _ghost_end_game() -> void:
	game_state.set_progression(GameStates.Progression.DeadEnd1)

func locked_player_movement(val: bool):
	player_controller.lock_movement = val
