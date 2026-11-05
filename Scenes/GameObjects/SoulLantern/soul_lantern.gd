extends GameObject
class_name SoulLantern

@export var detection_radius: float = 1:
	set(value):
		entity_detector_collision.shape.radius = value
@export var num_entities_required: int = 1
@export var connected_objects: Array[GameObject]
@export_category("Local Exports")
@export var sprite: Sprite3D
@export var entity_detector: Area3D
@export var entity_detector_collision: CollisionShape3D

var num_entities_in_radius: int = 0
var entities_in_radius: Array[Node3D] = []

func _ready() -> void:
	entity_detector_collision.shape.radius = detection_radius

func _on_entity_detector_body_entered(body: Node3D) -> void:
	num_entities_in_radius += 1
	entities_in_radius.append(body)
	if num_entities_in_radius >= num_entities_required:
		activate()

func _on_entity_detector_body_exited(body: Node3D) -> void:
	num_entities_in_radius -= 1
	entities_in_radius.erase(body)
	if num_entities_in_radius < num_entities_required:
		deactivate()

func activate() -> void:
	activated = true
	sprite.modulate = Color.BLUE
	for object: GameObject in connected_objects:
		object.on_activate(self)

func deactivate() -> void:
	activated = false
	sprite.modulate = Color.WHITE
	for object: GameObject in connected_objects:
		object.on_deactivate(self)
