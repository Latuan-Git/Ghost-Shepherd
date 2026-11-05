extends Area3D
class_name LureRing

@export var thickness: float = 0.1
@export var expansion_time: float = 0.8
@export var max_range: float = 3
@export var fade_distance: float = 0.3
@export var fade_time: float = 0.3
@export var color: Color = Color.WHITE
@export_category("Local Exports")
@export var collision: CollisionShape3D
@export var ring_mesh: MeshInstance3D

@onready var collision_cyl: CylinderShape3D = collision.shape
@onready var ring_mesh_torus: TorusMesh = ring_mesh.mesh

var expanding: bool = false
var expanding_tween: Tween
var finishing_tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_expanding()

func start_expanding() -> void:
	collision_cyl.radius = thickness
	ring_mesh_torus.outer_radius = thickness

	expanding_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	expanding_tween.tween_property(collision_cyl, "radius", max_range, expansion_time)
	expanding_tween.parallel().tween_property(ring_mesh_torus, "outer_radius", max_range, expansion_time)
	expanding_tween.parallel().tween_property(ring_mesh_torus, "inner_radius", max_range-thickness, expansion_time)
	expanding_tween.parallel().tween_property(ring_mesh_torus.material, "albedo_color", Color(color.r, color.g, color.b, 1), expansion_time)

	await expanding_tween.finished

	finish_expanding()

func finish_expanding() -> void:
	expanding_tween.stop()
	finishing_tween = create_tween().set_ease(Tween.EASE_OUT)#.set_trans(Tween.TRANS_CUBIC)
	finishing_tween.tween_property(ring_mesh_torus, "outer_radius", max_range + fade_distance, fade_time)
	finishing_tween.parallel().tween_property(ring_mesh_torus, "inner_radius", max_range + fade_distance - thickness, fade_time)
	finishing_tween.parallel().tween_property(ring_mesh_torus.material, "albedo_color", Color(color.r, color.g, color.b, 0), fade_time)

	await finishing_tween.finished

	queue_free()