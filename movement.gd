extends CharacterBody3D

const SPEED = 5
@export var forward: bool = true


func _physics_process(delta):
	if forward:
		velocity = Vector3(0, 0, SPEED)
	move_and_slide()
