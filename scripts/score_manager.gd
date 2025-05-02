class_name ScoreManager
extends Node

@export var player: PlayerController

@export var init_score: float

@export var natural_decay_speed: float

@export_group("warmup")
@export var warmup_duration: float
@export var warmup_decrease_duration: float

# for the tiny figure UI
@export_group("figure")
@export var positive_state_threshold: float
@export var neutural_state_threshold: float
@export var negative_state_threshold: float

# selfie
@export_group("selfie")
@export var selfie_threshold: float
@export var selfie_increase_speed: float
@export var selfie_check_interval: float
@export_range(0, 1) var selfie_caught_rate_increase_speed: float
@export_range(0, 1) var selfie_caught_rate_decrease_speed: float
@export_range(0, 1) var selfie_chat_weight_increase_speed: float
@export_range(0, 1) var selfie_chat_weight_decrease_speed: float

@export_group("anomaly")
@export var anomaly_score_acceleration: float = 10
@export var anomaly_score_deceleration: float = 10
@export var max_anomaly_score_increase_speed: float = 50
@export var anomaly_ghost_score: float = 20
@export var anomaly_weight_acceleration: float = 0.1
@export var anomaly_weight_deceleration: float = 0.1
@export var max_anomaly_weight_speed: float = 0.5
@export var anomaly_duration: float = 8
@export var max_anomaly_duration: float = 15
@export var anomaly_decrease_speed: float = 0.1

var anomaly_score_speed: float
var anomaly_weight_speed: float
var anomaly_timer: float

var score: float

var warmup_timer: float

# selfie runtime
var can_selfie: bool
var is_selfing: bool
var selfie_caught_rate: float
var selfie_check_timer: float

var ghost_score: float
var ghost_score_threshold: float

var chat_refresh_speed: float

var current_ghosting_level: int = 0

# 0 is warmup bucket
# 1 is boring bucket
# 2 is anomaly event bucket
# 3 is selfie bucket
# 4 is sacrifice bucket
@export var message_buckets: Array[MessageFlow]

func anomaly_observed():
	ghost_score += anomaly_ghost_score
	anomaly_timer = clamp(anomaly_timer + anomaly_duration, 0, max_anomaly_duration)

func _ready() -> void:
	message_buckets[0].weight = 0.8
	warmup_timer = warmup_duration

func _process(delta: float) -> void:
	# warmup & boring
	warmup_timer = clamp(warmup_timer - delta, 0, warmup_duration)
	message_buckets[0].weight = clamp(warmup_timer / warmup_decrease_duration, 0, 0.8)
	if warmup_timer < warmup_decrease_duration:
		message_buckets[1].weight = 0.2

	# selfie logic
	can_selfie = score < selfie_threshold
	if is_selfing:
		selfie_caught_rate = clamp(selfie_caught_rate + selfie_caught_rate_increase_speed * delta, 0, 1)
		message_buckets[3].weight = clamp(message_buckets[3].weight + selfie_chat_weight_increase_speed * delta, 0, 1)
	else:
		selfie_caught_rate = clamp(selfie_caught_rate - selfie_caught_rate_decrease_speed * delta, 0, 1)
		message_buckets[3].weight = clamp(message_buckets[3].weight - selfie_caught_rate_decrease_speed * delta, 0, 1)
	selfie_check_timer = clamp(selfie_check_timer - delta, 0, selfie_check_interval)
	if selfie_check_timer == 0:
		if is_selfing and randf() < selfie_caught_rate:
			print("caught!!!")
		selfie_check_timer = selfie_check_interval

	# anomaly
	anomaly_timer = clamp(anomaly_timer - delta, 0, anomaly_duration)
	if anomaly_timer > 0:
		anomaly_score_speed = clamp(anomaly_score_speed + anomaly_score_acceleration * delta, 0, max_anomaly_score_increase_speed)
		anomaly_weight_speed = clamp(anomaly_weight_speed + anomaly_weight_acceleration * delta, 0, max_anomaly_weight_speed)
	else:
		anomaly_score_speed = clamp(anomaly_score_speed - anomaly_score_deceleration * delta, 0, max_anomaly_score_increase_speed)
		anomaly_weight_speed = 0
	anomaly_weight_speed = clamp(anomaly_weight_speed - anomaly_weight_deceleration * delta, 0, max_anomaly_weight_speed)
	message_buckets[2].weight = clamp(message_buckets[2].weight + anomaly_weight_speed * delta - anomaly_decrease_speed, 0, 1)
	score += anomaly_score_speed * delta
