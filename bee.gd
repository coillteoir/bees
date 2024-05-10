extends CharacterBody3D

var movements: Array[Callable] = []

#Boid properties
enum Status {Wandering, Arriving, Returning}
var status: Status

const MAX_DIST_FROM_HIVE = 20

const MAX_FORCE: float = 10.0

const mass = 1
var vel: Vector3 = Vector3.ZERO
var force: Vector3 = Vector3.ZERO
var acceleration: Vector3 = Vector3.ZERO
var speed: float
var max_speed: float
var max_rotation_speed: float = 350

const POLLEN_COLLECT_TIME = 3

#Arrive vars
var arriveTarget: Node3D = null
const ARRIVE_MAX_SPEED = 10
const SLOWING_DISTANCE = 30

#Noise Wander Vars
enum Axis { Horizontal, Vertical }

const WANDER_AMP = 2000
const WANDER_DIST = 5
const AXIS = Axis.Horizontal
const WANDER_FREQ = 0.3
const WANDER_RADIUS = 10.0
const WANDER_MAX_SPEED = 2

var theta = 0
var wanderTarget: Vector3
var world_target: Vector3
var noise: FastNoiseLite = FastNoiseLite.new()


#Scene nodes 
var hive: Node3D
var exitTarget: Node3D


func _ready():
	#Get scene nodes 
	hive = get_parent()
	exitTarget = hive.find_child("exitPoint")
	
	setStatusArrive(exitTarget)


func _physics_process(delta):
	if (status == Status.Wandering):	
		var distFromHive = hive.global_transform.origin.distance_to(global_transform.origin)
				
		if (distFromHive > MAX_DIST_FROM_HIVE):
			setStatusArrive(hive)
	
	applyForce(delta)
	applyRotation(delta)


func _arrive() -> Vector3:
	#get vector to target
	var toTarget = arriveTarget.global_transform.origin - global_transform.origin
	
	#get distance to target
	var distToTarget = toTarget.length()

	#if distance is less than 2, stop
	if distToTarget < 2:
		return Vector3.ZERO

	#sets speed based on ratio between dist and slowingDistance, scaled to max_speed
	var rampedSpeed = (distToTarget / SLOWING_DISTANCE) * max_speed

	#Limit speed
	var limitedSpeed = min(max_speed, rampedSpeed)

	#desired velcity vector to get to target
	var desiredVel = (toTarget * limitedSpeed) / distToTarget

	#returns steering force
	return desiredVel - vel


func _noiseWander() -> Vector3:
	#get noise value for current theta
	var n = noise.get_noise_1d(theta)

	var angle = deg_to_rad(n * WANDER_AMP)

	var delta = get_process_delta_time()

	var rot = global_transform.basis.get_euler()

	rot.x = 0

	#Calculate wander vector
	if AXIS == Axis.Horizontal:
		wanderTarget.x = sin(angle)
		wanderTarget.y = 0
		wanderTarget.z = cos(angle)
		rot.z = 0
	else:
		wanderTarget.x = 0
		wanderTarget.y = sin(angle)
		wanderTarget.z = cos(angle)

	#scale wander target by radius
	wanderTarget *= WANDER_RADIUS

	var local_target = wanderTarget + (Vector3.BACK * WANDER_DIST)

	var projected = Basis.from_euler(rot)

	world_target = global_transform.origin + (projected * local_target)
	theta += WANDER_FREQ * delta * PI * 2.0

	var toTarget = world_target - global_transform.origin
	toTarget = toTarget.normalized()
	var desired = toTarget * max_speed
	return desired - vel


func setStatusArrive(target):
	status = Status.Arriving
	movements.clear()
	movements.append(_arrive)
	arriveTarget = target
	max_speed = ARRIVE_MAX_SPEED;


func setStatusReturning(target):
	status = Status.Returning
	movements.clear()
	movements.append(_arrive)
	arriveTarget = target
	max_speed = ARRIVE_MAX_SPEED;


func setStatusWander():
	status = Status.Wandering
	
	var rng = RandomNumberGenerator.new()
	theta = rng.randf_range(0, 10.0)
	
	movements.clear()
	movements.append(_noiseWander)
	max_speed = WANDER_MAX_SPEED


func calculate() -> Vector3:
	var forceAccumulator = Vector3.ZERO

	for i in range(movements.size()):
		forceAccumulator += movements[i].call()

	#limit force
	if forceAccumulator.length() > MAX_FORCE:
		forceAccumulator = force.limit_length(MAX_FORCE)

	return forceAccumulator


func applyForce(delta):
	var newForce = calculate()

	force = lerp(force, newForce, delta)

	acceleration = force / mass

	#multiply acceleration by delta (time since last frame) to account for inconsistent framerate
	vel += acceleration * delta

	speed = vel.length()

	if speed > 0:
		vel = vel.limit_length(max_speed)

		set_velocity(vel)
		move_and_slide()


func applyRotation(delta):
	# Calculate the direction vector of movement based on the velocity
	var direction = vel.normalized()
	
	# If the velocity is not zero (i.e., the bee is moving)
	if direction.length() > 0:
		# Calculate pitch (rotation around the x-axis)
		var pitch = asin(-direction.y) * 180 / PI
		
		# Ensure the pitch angle is within [-90, 90] degrees
		pitch = clamp(pitch, -90.0, 90.0)
		
		# Apply pitch rotation to the bee
		rotation_degrees.x = pitch
		
		# Convert the direction vector to a rotation in radians
		var target_pitch = atan2(direction.x, direction.z) * 180 / PI

		# Ensure the target angle is within [0, 360] degrees
		target_pitch = fmod(target_pitch + 180.0 + 360.0, 360.0)

		# Calculate the angle difference between current and target angles
		var current_pitch = rotation_degrees.y
		var pitch_diff = (target_pitch - current_pitch + 180.0)
		pitch_diff = fmod(pitch_diff + 180.0, 360.0) - 180.0

		# Choose the shortest rotation direction
		if abs(pitch_diff) > 180:
			pitch_diff -= 360.0 * sign(pitch_diff)

		# Smoothly rotate the bee towards the target angle
		rotation_degrees.y += clamp(pitch_diff, -max_rotation_speed * delta, max_rotation_speed * delta)


func _on_bee_area_entered(area: Area3D):
	print(area.name)
	
	if area.name == "exitPoint" and status == Status.Arriving:
		setStatusWander()
	
	#If attracted by flower, start heading towards it
	if area.name == "flowerAttraction" and status == Status.Wandering:
			var flower = area.get_parent()
			var flowerTarget = flower.get_node("Pollen")
			
			if flower.is_pollinated():
				flower.set_pollination(false)
				print("POLLEN TAKEN")
				setStatusArrive(flowerTarget)
			else:
				print("NO POLLEN")
		
	#If in pollen return to hive
	if area.name == "flowerPollen":
		get_node("GPUParticles3D").emitting = true
		setStatusReturning(hive) 
