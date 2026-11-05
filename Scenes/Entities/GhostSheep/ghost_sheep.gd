extends CharacterBody3D

@export var max_follow_distance: float = 1.5
@export var sprite: AnimatedSprite3D

const SPEED = 1.8

var following: Node3D

func _physics_process(delta: float) -> void:
	if following && global_position.distance_to(following.global_position) >= max_follow_distance:
		var direction : Vector3 = global_position.direction_to(following.global_position).normalized()
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		sprite.play("run")

		if direction.z > 0:
			sprite.flip_h = false
		elif direction.z < 0:
			sprite.flip_h = true
		
	else:
		sprite.play("idle")
		velocity = velocity.move_toward(Vector3.ZERO, SPEED)

	move_and_slide()

func on_lure(entity: Node3D) -> void:
	following = entity

func on_halt() -> void:
	following = null