extends Control

@export var pool_size := 20
@export var message_scene : PackedScene
@export var scroll_duration := 0.3  # 滚动动画持续时间（秒）
@export var vertical_spacing := 10.0  # 消息间距
@export var entry_offset := Vector2(0, 50)  # 新消息进入偏移量
@export var speed_increase_factor := 0.2  # 每条消息的速度加快比例
@export var min_duration := 0.1  # 最小动画持续时间

@export var target: Control  # 目标容器节点

var message_pool : Array = []
var active_messages := []
var is_processing = false
var message_queue = []

func _ready():
	# 预生成消息池
	for i in range(pool_size):
		var msg = message_scene.instantiate()
		msg.visible = false
		message_pool.append(msg)
		target.add_child(msg)

func add_message(text: String, type):
	if is_processing:
		message_queue.append({"text": text, "type": type})
		return
	
	is_processing = true
	var msg = get_available_message()
	msg.set_content(text, type)
	
	# 初始位置设置在可视区域下方
	msg.visible = true
	msg.position = Vector2(entry_offset.x, target.size.y + entry_offset.y)

	
	var container_height = target.size.y
	var msg_height = msg.size.y
	
	# 动态计算动画持续时间
	var current_duration = scroll_duration / (1.0 + active_messages.size() * speed_increase_factor)
	current_duration = max(current_duration, min_duration)
	
	var tween = create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	
	# 新消息入场动画
	tween.tween_property(msg, "position", 
		Vector2(0, container_height - msg_height), 
		current_duration
	)
	
	# 现有消息上移动画
	for existing_msg in active_messages:
		var target_y = existing_msg.position.y - (msg_height + vertical_spacing)
		tween.tween_property(existing_msg, "position:y", 
			target_y, 
			current_duration
		)
	
	active_messages.append(msg)
	
	tween.finished.connect(func():
		check_recycle_messages()
		is_processing = false
		process_next_message()
	)

func get_available_message():
	# 优先使用池中消息
	for msg in message_pool:
		if not msg.visible:
			message_pool.erase(msg)
			return msg
	# 强制回收最旧消息
	var oldest = active_messages.pop_front()
	recycle_message(oldest)
	return oldest

func check_recycle_messages():
	# 检查超出容器的消息
	for msg in active_messages.duplicate():
		if msg.position.y + msg.size.y < 0:
			recycle_message(msg)

func recycle_message(msg):
	msg.visible = false
	active_messages.erase(msg)
	message_pool.append(msg)

func process_next_message():
	if message_queue.size() > 0:
		var next = message_queue.pop_front()
		add_message(next.text, next.type)
