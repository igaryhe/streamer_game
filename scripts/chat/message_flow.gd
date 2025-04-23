extends Control

#var contents = [
	#[9,"开始了！", ChatMessage.MessageType.MESSAGE],
	#[1,"", ChatMessage.MessageType.DONATION],
	#[1,"直播了！", ChatMessage.MessageType.DONATION_TEXT],
#]

@export var script_uid : String

@export var weight : float = 0
@export var max_interval : float = 5
@export var min_interval : float = 0.2
@onready var chat_window  = $"../ChatWindow"
var time : float = 0
var message_time : float = 0

var arr_text :Array = []
var arr_weight : Array = []
var arr_type : Array = []
var rng : RandomNumberGenerator 

func _ready() -> void:
	rng = RandomNumberGenerator.new()
	var res = load(script_uid).new()
	var contents = res.contents
	for i in contents:
		arr_weight.append(i[0])
		arr_text.append(i[1])
		arr_type.append(i[2])
	

# Debug usage
func _process(delta: float) -> void:
	time += delta
	if (weight == 0 ): return
	var interval = remap(weight, 0, 1, max_interval, min_interval)
	if (time - message_time > interval):
		var index = rng.rand_weighted(arr_weight)
		chat_window.add_message(arr_text[index],arr_type[index])
		message_time = time
