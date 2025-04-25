extends Node3D

var interacted: bool = false

@export var interact_item: int = -1
@export var objects_to_show: Array[Node3D]
@export var objects_to_hide: Array[Node3D]
@export var animation: AnimationPlayer
@export var sfx: AudioStreamPlayer3D

func _ready():
	for obj in objects_to_show:
		obj.visible = false
	for obj in objects_to_hide:
		obj.visible = true

func on_interact(player_controller):
	if interact_item >= 0 and player_controller.holding_item != interact_item:
		return
	if interacted:
		return
	interacted = true
	for obj in objects_to_show:
		obj.visible = true
	for obj in objects_to_hide:
		obj.visible = false
	animation.play()
	sfx.play()
