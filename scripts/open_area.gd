class_name OpenArea
extends Area3D

var is_player_inside = false

func _enter_tree() -> void:
    SLocator.with(self).register(self)

func _on_body_entered(body: Node3D) -> void:
    if body.is_in_group("player"):
        is_player_inside = true
func _on_body_exited(body: Node3D) -> void:
    if body.is_in_group("player"):
        is_player_inside = false
