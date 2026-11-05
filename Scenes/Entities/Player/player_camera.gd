extends Camera3D
@export var player: Player
@export var follow_distance: float = 0.0
@export var follow_speed: float = 2
@export var look_ahead: float = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	smooth_to_player(delta)


func smooth_to_player(delta) -> void:
	position.z = lerp(position.z, player.position.z, delta * follow_speed)
	h_offset = lerp(h_offset, player.player_facing * look_ahead, delta * follow_speed)
