extends GameObject

@export_category("Local Exports")
@export var gate_mesh: MeshInstance3D
@export var collision: CollisionShape3D

func on_activate(_trigger: GameObject) -> void:
	collision.disabled = true
	gate_mesh.mesh.material.albedo_color = Color(1, 1, 1, 0.25)

func on_deactivate(_trigger: GameObject) -> void:
	collision.disabled = false
	gate_mesh.mesh.material.albedo_color = Color(1, 1, 1, 1)