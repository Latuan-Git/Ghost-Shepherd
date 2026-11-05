extends Node
class_name MainScene

@export var starting_scene: String
@export_category("Local Exports")
@export var root3d: Node3D
@export var rootui: Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Scenes.main_scene = self
	Scenes.add_3d_scene(starting_scene)
