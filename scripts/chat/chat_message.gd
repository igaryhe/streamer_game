extends Control
class_name ChatMessage

enum MessageType {MESSAGE, DONATION, DONATION_TEXT, DONATION_TEXT_MAX}

@export var bg_0: Control
@export var bg_1: Control
@export var bg_2: Control
	
@export var content_label: RichTextLabel

@export var total_chars: int = 25
var chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"


func set_content(text: String, type: MessageType) -> void:
	bg_0.visible = false; bg_1.visible = false; bg_2.visible = false
	match type:
		MessageType.MESSAGE:
			bg_0.visible = true
			content_label.visible = true
		MessageType.DONATION:
			bg_1.visible = true
			content_label.visible = false
		MessageType.DONATION_TEXT:
			bg_2.visible = true
			content_label.visible = true
	
	content_label.text = random_name(total_chars - len(text) - 2) + ": " + text
	
func random_name(force_total: int = -1) -> String:
	var star_count = randi_range(2, 5)
	var first = chars[randi() % len(chars)]
	var last = chars[randi() % len(chars)]
	var max_count = 8 if force_total >= 2 else force_total
	var stars = "*".repeat(randi_range(1, max_count))
	return first + stars + last
