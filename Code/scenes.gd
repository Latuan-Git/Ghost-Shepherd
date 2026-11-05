extends Node
class_name ScenesManager

var main_scene: MainScene

const SCENE_DICTIONARY: Dictionary = {
	# UI
	"title_screen": "",

	# LEVELS
	"test_level": "res://Scenes/Levels/test_level.tscn",
}

func add_3d_scene(scene_name: String) -> void:
	main_scene.root3d.add_child(load(SCENE_DICTIONARY[scene_name]).instantiate())

func add_ui_scene(scene_name: String) -> void:
	main_scene.rootui.add_child(load(SCENE_DICTIONARY[scene_name]).instantiate())