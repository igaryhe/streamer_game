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

func _enter_tree() -> void:
	SLocator.with(self).register(self)

func _ready() -> void:
	dead_end_1.visible = false
	dead_end_2.visible = false
	game_finished.visible = false

func set_progression(p: Progression) -> void:
	state = p
	match (state):
		Progression.Streaming:
			dead_end_1.visible = false
			dead_end_2.visible = false
			game_finished.visible = false
		Progression.DeadEnd1:
			dead_end_1.visible = true
		Progression.DeadEnd2:
			dead_end_2.visible = true
		Progression.Finished:
			game_finished.visible = true
