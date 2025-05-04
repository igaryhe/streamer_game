extends Control
class_name GameStates

enum Progression {
	Streaming,
	DeadEnd1,
	DeadEnd2,
	Finished
}

@export var dead_end_1: Control
@export var dead_end_2: Control
@export var game_finished: Control
@export var chat_window: Control

@export var state: Progression

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var score_manager: ScoreManager = SLocator.with(self).fetch(ScoreManager)


@export var wait_duration: float = 3.5

func _enter_tree() -> void:
	SLocator.with(self).register(self)

func _ready() -> void:
	dead_end_1.visible = false
	dead_end_2.visible = false
	game_finished.visible = false

func _process(delta: float) -> void:
	$UiV.visible = score_manager.can_selfie

func set_progression(p: Progression) -> void:
	state = p
	match (state):
		Progression.Streaming:
			dead_end_1.visible = false
			dead_end_2.visible = false
			game_finished.visible = false
		Progression.DeadEnd1:
			audio.play()
			dead_end_1.visible = true
			await get_tree().create_timer(wait_duration).timeout
			set_progression(Progression.Finished)
		Progression.DeadEnd2:
			dead_end_2.visible = true
			await get_tree().create_timer(wait_duration).timeout
			set_progression(Progression.Finished)
		Progression.Finished:
			if (!audio.playing): audio.play()
			game_finished.visible = true
			$Finished/lbDanmu.text = str(chat_window.message_count)
			$Finished/lbAudianNum.text = "%.0f" % score_manager.score
			$Finished/lbReward.text = str(chat_window.donation)
