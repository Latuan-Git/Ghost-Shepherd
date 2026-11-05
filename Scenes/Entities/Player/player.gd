extends CharacterBody3D
class_name Player

@export var lure_ring_size: float = 2.5:
	set(value):
		resize_lure_ring(value)
		lure_ring_size = value

@export var lure_ring_thickness: float = 0.2
@export var lure_ring_distance_thickness: float = 0.1
@export_category("Local Exports")
@export var sprite: AnimatedSprite3D
@export var lure_ring_effect: CPUParticles3D
@export var lure_ring_detection: Area3D
@export var lure_ring_detection_shape: CollisionShape3D
@export var lure_distance_display: MeshInstance3D

const SPEED = 2.0
enum Facing {LEFT = -1, RIGHT = 1}
var player_facing: Facing = Facing.RIGHT

var can_lure: bool = true
var entities_following: Array[Node3D]

func _ready() -> void:
	resize_lure_ring(lure_ring_size)

func _physics_process(_delta: float) -> void:
	var input_dir : Vector2 = Input.get_vector("Move Left", "Move Right", "Move Up", "Move Down")
	if input_dir.x > 0:
		player_facing = Facing.RIGHT
		sprite.flip_h = false
	elif input_dir.x < 0:
		player_facing = Facing.LEFT
		sprite.flip_h = true	
	var direction : Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		sprite.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		sprite.play("idle")

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Lure") && can_lure:
		activate_lure()
	
	if event.is_action_pressed("Halt") && can_lure:
		activate_halt()

func resize_lure_ring(new_size: float) -> void:
	var ring_mesh: TorusMesh = lure_ring_effect.mesh
	ring_mesh.outer_radius = new_size
	ring_mesh.inner_radius = new_size - lure_ring_thickness
	var ring_shape: CylinderShape3D = lure_ring_detection_shape.shape
	ring_shape.radius = new_size
	var ring_distance_display: TorusMesh = lure_distance_display.mesh
	ring_distance_display.outer_radius = new_size
	ring_distance_display.inner_radius = new_size - lure_ring_distance_thickness

func activate_lure() -> void:
	var origin_point: Vector3 = global_position
	var lure_list: Array[Node3D]
	for body in lure_ring_detection.get_overlapping_bodies():
		if body.has_method("on_lure"):
			distance_sort_add(body, origin_point, lure_list)
			entities_following.append(body)
	lure_ring_effect.emitting = true
	can_lure = false

	for body in lure_list:
		print(str(body) + ": Distance from center - " + str(body.global_position.distance_to(origin_point)))

	var time_waited: float = 0
	for body in lure_list:
		var percentage_from_center: float = body.global_position.distance_to(origin_point)/lure_ring_size
		print("distance: " + str(body.global_position.distance_to(origin_point)) + " - Ring Size: " + str(lure_ring_size) + " - Percent from center: " + str(percentage_from_center))
		print("Waiting " + str(percentage_from_center) + " (PFC) - " + str(time_waited) + " (TW) = " + str(percentage_from_center-time_waited) + " secs")
		await get_tree().create_timer(percentage_from_center-time_waited).timeout
		time_waited += percentage_from_center-time_waited
		print("Time waited: " + str(time_waited))

		body.on_lure(self)
		print("lured")


	can_lure = true

func activate_halt() -> void:
	for entity in entities_following:
		if entity.has_method("on_halt"):
			entity.on_halt()

func distance_sort_add(body: Node3D, origin_point: Vector3, array: Array) -> void:
	if array.is_empty():
		array.append(body)
		return
	
	for item in array:
		if body.global_position.distance_to(origin_point) <= item.global_position.distance_to(origin_point):
			array.insert(array.find(item), body)
			return
	
	array.append(body)
	return
