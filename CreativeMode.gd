extends CharacterBody3D

const SPEED = 5.0


func _physics_process(delta):
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var input_up = Vector3(0, 0, 0)

	if Input.is_action_just_pressed("rise"):
		input_up.y = SPEED
	if Input.is_action_just_pressed("fall"):
		input_up.y = SPEED * -1

	var direction = (transform.basis * Vector3(input_dir.x, input_up.y, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		velocity.y = direction.y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
