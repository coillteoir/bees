extends CharacterBody3D

var movements: Array[Callable] = []

#Boid properties
enum Status {Wandering, Arriving}
var status:Status

const MAX_DIST_FROM_HIVE = 20

const MAX_FORCE: float = 10.0

const mass = 1
var vel: Vector3 = Vector3.ZERO
var force: Vector3 = Vector3.ZERO
var acceleration: Vector3 = Vector3.ZERO
var speed: float
var max_speed:float
var rotation_speed:float = 350

const POLLEN_COLLECT_TIME = 3

#Arrive vars
var arriveTarget: Node3D = null
const ARRIVE_MAX_SPEED = 10
const SLOWING_DISTANCE = 30


#Noise Wander Vars
enum Axis { Horizontal, Vertical}

const WANDER_AMP = 2000
const WANDER_DIST = 5
const AXIS = Axis.Horizontal
const WANDER_FREQ = 0.3
const WANDER_RADIUS = 10.0
const WANDER_MAX_SPEED = 2

var theta = 0
var wanderTarget:Vector3
var world_target:Vector3
var noise:FastNoiseLite = FastNoiseLite.new()

#Scene nodes 
var hive:Node3D
var testTarget:Node3D

func _arrive() -> Vector3:

	#get vector to target
	var toTarget = arriveTarget.global_transform.origin - global_transform.origin
	var distToTarget = toTarget.length()  #get distance to target

	if distToTarget < 2:  #if distance is less than 2, stop
		return Vector3.ZERO
		
	var rampedSpeed = (distToTarget / SLOWING_DISTANCE) * max_speed #sets speed based on ratio between dist and slowingDistance, scaled to max_speed
	
	var limitedSpeed = min(max_speed, rampedSpeed) #Limit speed
	var desiredVel = (toTarget * limitedSpeed) / distToTarget #desired velcity vector to get to target
	return desiredVel - vel #returns steering force		
	
func _noiseWander() -> Vector3:
	var n  = noise.get_noise_1d(theta) #get noise value for current theta
	
	var angle = deg_to_rad(n * WANDER_AMP) 
	
	var delta = get_process_delta_time()

	var rot = global_transform.basis.get_euler()
	
	rot.x = 0
	
	#Calculate wander vector
	if AXIS == Axis.Horizontal:
		wanderTarget.x = sin(angle)
		wanderTarget.y = 0
		wanderTarget.z =  cos(angle)		
		rot.z = 0
	else:
		wanderTarget.x = 0
		wanderTarget.y = sin(angle)
		wanderTarget.z = cos(angle)		
		
	wanderTarget *= WANDER_RADIUS #scale wander target by radius

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
	
func setStatusWander():
	status = Status.Wandering
	
	var rng = RandomNumberGenerator.new()
	theta = rng.randf_range(0, 10.0)
	
	movements.clear()
	movements.append(_noiseWander)
	max_speed = WANDER_MAX_SPEED
		
func _ready():
	#Get scene nodes 
	testTarget = get_tree().current_scene.find_child("testTarget")
	hive = get_parent()
	
	setStatusWander()

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
		# Convert the direction vector to a rotation in radians
		var target_angle = atan2(direction.x, direction.z) * 180 / PI
		
		# Ensure the target angle is within [0, 360] degrees
		target_angle = fmod(target_angle + 180.0 + 360.0, 360.0)
		
		# Calculate the angle difference between current and target angles
		var current_angle = rotation_degrees.y
		var angle_diff = (target_angle - current_angle + 180.0)
		angle_diff = fmod(angle_diff + 180.0, 360.0) - 180.0
		
		# Choose the shortest rotation direction
		if abs(angle_diff) > 180:
			angle_diff -= 360.0 * sign(angle_diff)
		
		# Smoothly rotate the bee towards the target angle
		rotation_degrees.y += clamp(angle_diff, -rotation_speed * delta, rotation_speed * delta)

	
func _physics_process(delta):
	if (status == Status.Wandering):	
		var distFromHive = hive.global_transform.origin.distance_to(global_transform.origin)
				
		if (distFromHive > MAX_DIST_FROM_HIVE):
			setStatusArrive(hive)
	
	applyForce(delta)
	applyRotation(delta)

# Returning to hive after going to flower
func _on_area_3d_area_entered(area: Area3D):
	print(area.name)
	
	#If attracted by flower, start heading towards it
	if area.name == "flowerAttraction" and status == Status.Wandering:  
		var flower = area.get_parent()
		setStatusArrive(flower)
		
	#If in pollen return to hive
	if area.name == "flowerPollen":		
		setStatusArrive(hive) 
		
	
	






