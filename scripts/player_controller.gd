class_name PlayerController
extends CharacterBody3D

var speed
const WALK_SPEED = 3.0
const SPRINT_SPEED = 10.0
const JUMP_VELOCITY = 4.8
const SENSITIVITY = 0.004

#bob variables
const BOB_FREQ = 3.2
const BOB_AMP = 0.08
var t_bob = 0.0

#fov variables
#const BASE_FOV = 75.0
#const FOV_CHANGE = 1.5

const interaction_layer = 2
const obsersvation_layer = 3

const interact_signal = "on_interact"
var observation_timer: float = 0
@export var observation_threshold: float

var holding_item: int = -1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8

@export var items: Items
@export var item_prefab: PackedScene
@export var score_manager: ScoreManager

@onready var head = $head
@onready var camera = $head/camera
@onready var raycast = $head/raycast
@onready var observer = $head/observer
@onready var hand = $hand
@onready var holding_item_view: TextureRect = $holding_item

@onready var camera_anim = $AnimationPlayer
var is_front_camera: bool = true

func _enter_tree() -> void:
	SLocator.with(self).register(self)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if (!is_front_camera): return
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta):
	if Input.is_action_just_pressed("flip_camera") && !camera_anim.is_playing():
		if is_front_camera:
			camera_anim.play("to_back_camera")
			score_manager.is_selfing = true
		else:
			camera_anim.play("to_front_camera")
			score_manager.is_selfing = false
		is_front_camera = !is_front_camera

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if (!is_front_camera): return

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Handle Sprint.
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	
	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# FOV
	#var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	#var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	#camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()
	
	# interaction
	var interacted = Input.is_action_just_pressed("interact")
	if raycast.is_colliding():
		hand.visible = true
		var collider = raycast.get_collider()
		if collider is Interactable:
			if collider.can_interact(holding_item):
				if interacted:
					collider.interact(holding_item)
					if collider.expected_item_ids.size() > 0:
						holding_item = -1
			else:
				hand.visible = false
		elif collider is CollisionObject3D and collider.is_in_group("item") and interacted:
			var item: Item = collider.get_parent() as Item
			var item_id = item.id
			if holding_item >= 0:
				# drop current holding item
				var mat: StandardMaterial3D = item.mesh.get_surface_override_material(0) as StandardMaterial3D
				mat.albedo_texture = items.items[holding_item].texture
				item.id = holding_item
			else:
				item.queue_free()
			holding_item = item_id
	else:
		hand.visible = false
		
	if observer.is_colliding():
		observation_timer += delta
		if (observation_timer >= observation_threshold):
			observation_timer = 0
			observer.get_collider().set_collision_layer_value(obsersvation_layer, false)
			print("anomaly observed")
			score_manager.anomaly_observed()
	elif observation_timer > 0:
		observation_timer = 0
	
	# change holding item
	if holding_item >= 0:
		holding_item_view.texture = items.items[holding_item].texture
	else:
		holding_item_view.texture = null
	# TODO(dan): adjust hand state

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
