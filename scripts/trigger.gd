extends Area3D

var interacted: bool = false

@export var objects_to_show: Array[Node3D]
@export var objects_to_hide: Array[Node3D]
@export var animation: AnimationPlayer
@export var sfx: AudioStreamPlayer3D

func _ready():
	for obj in objects_to_show:
		obj.visible = false
	for obj in objects_to_hide:
		obj.visible = true
	body_entered.connect(_on_body_enter)

func on_interact():
	if interacted:
		return
	interacted = true
	for obj in objects_to_show:
		obj.visible = true
	for obj in objects_to_hide:
		obj.visible = false
	if animation != null:
		animation.play()
	if sfx != null:
		sfx.play()
	
func _on_body_enter(body: Node3D):
	if !body.is_in_group("player"):
		return
	on_interact()
