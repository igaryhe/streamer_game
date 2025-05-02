class_name ScoreManager
extends Node

@export var init_score: float
@export var warmup_duration: float
@export var natural_decay_speed: float

# for the tiny figure UI
@export var positive_state_threshold: float
@export var neutural_state_threshold: float
@export var negative_state_threshold: float

# selfie
@export var selfie_threshold: float
@export var selfie_increase_speed: float
@export var selfie_check_interval: float
@export var selfie_caught_rate_increase_speed: float
@export var selfie_caught_rate_decrease_speed: float

var score: float

var selfie_caught_rate: float

var ghost_score: float
var ghost_score_threshold: float

var chat_refresh_speed: float

var current_ghosting_level: int = 0

# 0 is warmup bucket
# 1 is boring bucket
# 2 is paranormal event bucket
# 3 is selfie bucket
# 4 is sacrifice bucket
@export var chat_bucket_weights: Array[float]
