extends Label

@onready var score_manager: ScoreManager = SLocator.with(self).fetch(ScoreManager)

func _process(delta: float) -> void:
    self.text = "观看人数:%d" % [score_manager.score + 100]