@abstract
extends StaticBody3D
class_name GameObject

var activated: bool = false

func on_activate(_trigger: GameObject) -> void:
	pass

func on_deactivate(_trigger: GameObject) -> void:
	pass