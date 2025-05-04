extends Control

@export var streaming_screen : PackedScene

func _on_start_stream_pressed() -> void:
	get_tree().change_scene_to_packed(streaming_screen)
