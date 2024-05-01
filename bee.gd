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

const mass = 1
var vel: Vector3 = Vector3.ZERO
var force: Vector3 = Vector3.ZERO
var acceleration: Vector3 = Vector3.ZERO
var speed: float

var target: Node3D = null


#Noise Wander Vars
enum Axis { Horizontal, Vertical}

const WANDER_AMP = 2000
const WANDER_DIST = 5
const AXIS = Axis.Horizontal
const WANDER_FREQ = 0.3
const WANDER_RADIUS = 10.0

var theta = 0
var wanderTarget:Vector3
var world_target:Vector3
var noise:FastNoiseLite = FastNoiseLite.new()

func _closest_flower() -> Vector3:
	return Vector3(0, 0, 0)


func _forward() -> Vector3:
	return Vector3(0, 0, MAX_SPEED)


func _arrive() -> Vector3:
	const SLOWING_DISTANCE = 50
	#get vector to target
	var toTarget = target.global_transform.origin - global_transform.origin
	var distToTarget = toTarget.length()  #get distance to target

	if distToTarget < 2:  #if distance is less than 2, stop
		return Vector3.ZERO
		
	var rampedSpeed = (distToTarget / SLOWING_DISTANCE) * MAX_SPEED #sets speed based on ratio between dist and slowingDistance, scaled to max_speed
	
	var limitedSpeed = min(MAX_SPEED, rampedSpeed) #Limit speed
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
	print(theta)
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
	target = get_tree().current_scene.find_child("testTarget")
	if noiseWander:
		var rng = RandomNumberGenerator.new()
		theta = rng.randf_range(0, 10.0)


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

	acceleration = force / mass

	#multiply acceleration by delta (time since last frame) to account for inconsistent framerate
	vel += acceleration * delta

	speed = vel.length()

	if speed > 0:
		vel = vel.limit_length(MAX_SPEED)

		set_velocity(vel)
		move_and_slide()


func _on_area_3d_area_entered(area: Area3D):
	if area == target.find_child("Area3D"):
		print(self, " ENTERED TARGET")
		target = get_parent()
	pass
