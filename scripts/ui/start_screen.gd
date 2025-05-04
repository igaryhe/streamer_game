extends Control

@export var streaming_screen: PackedScene
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var button: Button = $StartScreen/StartStream

func _ready() -> void:
	audio.connect("finished", switch_scene)

func switch_scene() ->void:
	get_tree().change_scene_to_packed(streaming_screen)

func _on_start_stream_pressed() -> void:
	if (!audio.playing):
		audio.play()
		button.disabled = true
