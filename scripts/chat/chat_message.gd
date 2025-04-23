extends Control

enum MessageType { MESSAGE, DONATION, DONATION_TEXT }

@export var bg_0 : Control
@export var bg_1 : Control
@export var bg_2 : Control
	
@export var content_label : RichTextLabel
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
	content_label.text = random_name() + ": " + text
	
func random_name() -> String:
	var star_count = randi_range(2,5)
	var first = chars[randi() % len(chars)]
	var last = chars[randi() % len(chars)]
	var stars = "*".repeat(randi_range(2, 8))
	return first + stars + last
