extends Control

enum MessageType { MESSAGE, DONATION, DONATION_TEXT }

@export var content_label : RichTextLabel
var chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"


func set_content(text: String, type: int) -> void:
	content_label.text = random_name() + ": " + text
	
func random_name() -> String:
	var star_count = randi_range(2,5)
	var first = chars[randi() % len(chars)]
	var last = chars[randi() % len(chars)]
	var stars = "*".repeat(randi_range(2, 8))
	return first + stars + last
