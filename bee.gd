extends CharacterBody3D

#Boid properties
enum Status { Wandering, Arriving, Returning }
enum Axis { Horizontal, Vertical }

const MAX_DIST_FROM_HIVE = 400

const MAX_FORCE: float = 20.0

const MASS = 1

const POLLEN_COLLECT_TIME = 3

#Arrive vars

const ARRIVE_MAX_SPEED = 10
const SLOWING_DISTANCE = 30

#Noise Wander Vars

const WANDER_AMP = 2000
const WANDER_DIST = 5
const AXIS = Axis.Horizontal
const WANDER_FREQ = 0.3
const WANDER_RADIUS = 10.0
const WANDER_MAX_SPEED = 10

var arrive_target: Node3D = null
var movements: Array[Callable] = []
var theta = 0
var wander_target: Vector3
var world_target: Vector3
var noise: FastNoiseLite = FastNoiseLite.new()

#Scene nodes
var hive: Node3D
var exit_target: Node3D
var wing_left: MeshInstance3D
var wing_right: MeshInstance3D

#Wings
var flapping_up = true
var wing_rotation = 0  #counter of how much wing's been rotated

var status: Status

# Velocity stuff
var vel: Vector3 = Vector3.ZERO
var force: Vector3 = Vector3.ZERO
var acceleration: Vector3 = Vector3.ZERO
var speed: float
var max_speed: float
var max_rotation_speed: float = 350


func _ready():
	#Get scene nodes
	hive = get_parent()
	exit_target = hive.find_child("exitPoint")
	setup_wings()
	set_status_arrive(exit_target)


func setup_wings():
	wing_left = get_node("Bee Model/wingLeft")
	wing_right = get_node("Bee Model/wingRight")

	wing_left.rotate_z(-0.75)
	wing_left.global_position.y += tan(-0.75) * 0.1

	wing_right.rotate_z(0.75)
	wing_right.global_position.y -= tan(0.75) * 0.1


func _physics_process(delta):
	if status == Status.Wandering:
		var dist_from_hive = hive.global_transform.origin.distance_to(global_transform.origin)

		if dist_from_hive > MAX_DIST_FROM_HIVE:
			set_status_arrive(hive)
	animate_wings()
	apply_force(delta)
	apply_rotation(delta)


func animate_wings():
	var wing_speed = acceleration.length() / 5

	if flapping_up:
		wing_rotation += wing_speed

		wing_left.rotate_z(wing_speed)
		wing_left.global_position.y += tan(wing_speed) * 0.15

		wing_right.rotate_z(-wing_speed)
		wing_right.global_position.y -= tan(-wing_speed) * 0.15

		if wing_rotation >= 1.5:
			wing_rotation = 0
			flapping_up = false
	else:  #Flapping down
		wing_rotation += wing_speed

		wing_left.rotate_z(-wing_speed)
		wing_left.global_position.y += tan(-wing_speed) * 0.15

		wing_right.rotate_z(wing_speed)
		wing_right.global_position.y -= tan(wing_speed) * 0.15

		if wing_rotation >= 1.5:
			wing_rotation = 0
			flapping_up = true


func _arrive() -> Vector3:
	# ensure target exists before continuing
	if !is_instance_valid(arrive_target):
		arrive_target = null
		set_status_wander()
		return Vector3(0, 0, 0)

	#get vector to target
	var to_target = arrive_target.global_transform.origin - global_transform.origin

	#get distance to target
	var dist_to_target = to_target.length()

	#if distance is less than 2, stop
	if dist_to_target < 2:
		return Vector3.ZERO

	#sets speed based on ratio between dist and slowingDistance, scaled to max_speed
	var ramped_speed = (dist_to_target / SLOWING_DISTANCE) * max_speed

	#Limit speed
	var limited_speed = min(max_speed, ramped_speed)

	#desired velcity vector to get to target
	var desired_vel = (to_target * limited_speed) / dist_to_target

	#returns steering force
	return desired_vel - vel


func _noise_wander() -> Vector3:
	#get noise value for current theta
	var n = noise.get_noise_1d(theta)

	var angle = deg_to_rad(n * WANDER_AMP)

	var delta = get_process_delta_time()

	var rot = global_transform.basis.get_euler()

	rot.x = 0

	#Calculate wander vector
	if AXIS == Axis.Horizontal:
		wander_target.x = sin(angle)
		wander_target.y = 0
		wander_target.z = cos(angle)
		rot.z = 0
	else:
		wander_target.x = 0
		wander_target.y = sin(angle)
		wander_target.z = cos(angle)

	#scale wander target by radius
	wander_target *= WANDER_RADIUS

	var local_target = wander_target + (Vector3.BACK * WANDER_DIST)

	var projected = Basis.from_euler(rot)

	world_target = global_transform.origin + (projected * local_target)
	theta += WANDER_FREQ * delta * PI * 2.0

	var to_target = world_target - global_transform.origin
	to_target = to_target.normalized()
	var desired = to_target * max_speed
	return desired - vel


func set_status_arrive(target):
	status = Status.Arriving
	movements.clear()
	movements.append(_arrive)
	arrive_target = target
	max_speed = ARRIVE_MAX_SPEED


func set_status_returning(target):
	status = Status.Returning
	movements.clear()
	movements.append(_arrive)
	arrive_target = target
	max_speed = ARRIVE_MAX_SPEED


func set_status_wander():
	status = Status.Wandering

	var rng = RandomNumberGenerator.new()
	theta = rng.randf_range(0, 10.0)

	movements.clear()
	movements.append(_noise_wander)
	max_speed = WANDER_MAX_SPEED


func calculate() -> Vector3:
	var force_accumulator = Vector3.ZERO

	for i in range(movements.size()):
		force_accumulator += movements[i].call()

	#limit force
	if force_accumulator.length() > MAX_FORCE:
		force_accumulator = force.limit_length(MAX_FORCE)

	return force_accumulator


func apply_force(delta):
	var new_force = calculate()

	force = lerp(force, new_force, delta)

	acceleration = force / MASS

	#multiply acceleration by delta (time since last frame) to account for inconsistent framerate
	vel += acceleration * delta

	speed = vel.length()

	if speed == 0:
		return
	vel = vel.limit_length(max_speed)
	set_velocity(vel)
	move_and_slide()


func apply_rotation(delta):
	# Calculate the direction vector of movement based on the velocity
	var direction = vel.normalized()

	# If the velocity is not zero (i.e., the bee is moving)
	if direction.length() == 0:
		return
	var pitch = asin(-direction.y) * 180 / PI

	# Ensure the pitch angle is within [-90, 90] degrees
	pitch = clamp(pitch, -90.0, 90.0)

	# Apply pitch rotation to the bee
	rotation_degrees.x = pitch

	# Convert the direction vector to a rotation in radians
	var target_yaw = atan2(direction.x, direction.z) * 180 / PI

	# Ensure the target angle is within [0, 360] degrees
	target_yaw = fmod(target_yaw + 180.0 + 360.0, 360.0)

	# Calculate the angle difference between current and target angles
	var current_yaw = rotation_degrees.y
	var yaw_diff = target_yaw - current_yaw + 180.0
	yaw_diff = fmod(yaw_diff + 180.0, 360.0) - 180.0

	# Choose the shortest rotation direction
	if abs(yaw_diff) > 180:
		yaw_diff -= 360.0 * sign(yaw_diff)

	# Smoothly rotate the bee towards the target angle
	rotation_degrees.y += clamp(yaw_diff, -max_rotation_speed * delta, max_rotation_speed * delta)

	# Banking B)
	rotation_degrees.z = -1 * clamp(yaw_diff * 45, -45, 45)


func _on_bee_area_entered(area: Area3D):
	if area.name == "exitPoint" and status == Status.Arriving:
		set_status_wander()

	#If attracted by flower, start heading towards it
	if area.name == "flowerAttraction" and status == Status.Wandering:
		var flower = area.get_parent()
		var flower_target = flower.get_node("Pollen")

		if flower.is_pollinated():
			flower.set_pollination(false)
			print("POLLEN TAKEN")
			set_status_arrive(flower_target)
		else:
			print("NO POLLEN")

	#If in pollen return to hive
	if area.name == "flowerPollen":
		get_node("GPUParticles3D").emitting = true
		set_status_returning(hive)
