extends Control

@onready var score_manager: ScoreManager = SLocator.with(self).fetch(ScoreManager)
@export var baby_anim: AnimatedSprite2D

func _process(delta: float) -> void:
	if score_manager.can_selfie or score_manager.is_selfing:
		visible = true
	else:
		visible = false
	if score_manager.baby_state == ScoreManager.baby_state_t.happy:
		baby_anim.play("happy")
	elif score_manager.baby_state == ScoreManager.baby_state_t.normal:
		baby_anim.play("normal")
	elif score_manager.baby_state == ScoreManager.baby_state_t.sad:
		baby_anim.play("sad")
