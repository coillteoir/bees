extends CharacterBody3D

#Behaviours
@export var forward: bool = false
@export var closest: bool = false
@export var arrive: bool = false
@export var noiseWander: bool = true

var movements: Array[Callable] = []

#Boid properties
const MAX_SPEED: float = 1.0
const MAX_FORCE: float = 10.0

var mass = 1
var vel: Vector3 = Vector3.ZERO
var force: Vector3 = Vector3.ZERO
var acceleration: Vector3 = Vector3.ZERO
var speed: float

var target = null

#Noise Wander Vars
enum Axis { Horizontal, Vertical}

var wanderTarget:Vector3
var theta = 50
var amplitude = 200
var distance = 5
var noise:FastNoiseLite = FastNoiseLite.new()
var axis = Axis.Horizontal
var frequency = 0.3
var radius = 10.0
var world_target:Vector3

func _closest_flower() -> Vector3:
	return Vector3(0, 0, 0)

func _forward() -> Vector3:
	return Vector3(0, 0, MAX_SPEED)

func _arrive() -> Vector3:
	const SLOWING_DISTANCE = 50
	var toTarget = target.global_transform.origin - global_transform.origin #get vector to target
	var distToTarget = toTarget.length() #get distance to target
	
	if distToTarget < 2: #if distance is less than 2, stop
		return Vector3.ZERO
		
	var rampedSpeed = (distToTarget / SLOWING_DISTANCE) * MAX_SPEED #sets speed based on ratio between dist and slowingDistance, scaled to max_speed
	
	var limitedSpeed = min(MAX_SPEED, rampedSpeed) #Limit speed
	var desiredVel = (toTarget * limitedSpeed) / distToTarget #desired velcity vector to get to target
	return desiredVel - vel #returns steering force		
	
func _noiseWander() -> Vector3:
	var n  = noise.get_noise_1d(theta)
	print(n)
	
	var angle = deg_to_rad(n * amplitude)
	
	var delta = get_process_delta_time()

	var rot = global_transform.basis.get_euler()
	
	rot.x = 0
	if axis == Axis.Horizontal:
		wanderTarget.x = sin(angle)
		wanderTarget.y = 0
		wanderTarget.z =  cos(angle)		
		rot.z = 0
	else:
		wanderTarget.x = 0
		wanderTarget.y = sin(angle)
		wanderTarget.z = cos(angle)		
		
	wanderTarget *= radius

	var local_target = wanderTarget + (Vector3.BACK * distance)
	
	var projected = Basis.from_euler(rot)
	
	world_target = global_transform.origin + (projected * local_target)	
	theta += frequency * delta * PI * 2.0
	
	var toTarget = world_target - global_transform.origin
	toTarget = toTarget.normalized()
	var desired = toTarget * MAX_SPEED
	return desired - vel
		
func _init():
	if forward:
		movements.append(_forward)
	if closest:
		movements.append(_closest_flower)
	if arrive:
		movements.append(_arrive)
	if noiseWander:
		movements.append(_noiseWander)
		
func _ready():
	target = $"../testTarget"
	
func calculate() -> Vector3:
	var forceAccumulator = Vector3.ZERO
	
	for i in range(movements.size()):
		forceAccumulator += movements[i].call()
	
	#limit force
	if forceAccumulator.length() > MAX_FORCE:
		forceAccumulator = force.limit_length(MAX_FORCE)
	
	return forceAccumulator

func _physics_process(delta):	
	var newForce = calculate()

	force = lerp(force, newForce, delta)
		
	acceleration = force/mass
	
	#multiply acceleration by delta (time since last frame) to account for inconsistent framerate
	vel += acceleration * delta 
	
	speed = vel.length()
	
	if speed > 0:
		vel = vel.limit_length(MAX_SPEED)
		
		set_velocity(vel)
		move_and_slide()
	
	
