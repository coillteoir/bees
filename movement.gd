extends CharacterBody3D

var SPEED: int = 1


func _physics_process(delta):
	velocity = Vector3(0, 0, 1)
	move_and_slide()
