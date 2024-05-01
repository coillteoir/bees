extends CharacterBody3D

#Behaviours
@export var forward: bool = false
@export var closest: bool = false
@export var arrive: bool = true

var movements: Array[Callable] = []

#Boid properties
const MAX_SPEED: float = 10.0
const MAX_FORCE: float = 10.0

var mass = 1
var vel: Vector3 = Vector3.ZERO
var force: Vector3 = Vector3.ZERO
var acceleration: Vector3 = Vector3.ZERO
var speed: float

var target: Marker3D = null


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

	#sets speed based on ratio between dist and slowingDistance, scaled to max_speed
	var rampedSpeed = (distToTarget / SLOWING_DISTANCE) * MAX_SPEED

	var limitedSpeed = min(MAX_SPEED, rampedSpeed)  #Limit speed
	#desired velcity vector to get to target
	var desiredVel = (toTarget * limitedSpeed) / distToTarget
	return desiredVel - vel  #returns steering force


func _init():
	if forward:
		movements.append(_forward)
	if closest:
		movements.append(_closest_flower)
	if arrive:
		movements.append(_arrive)


func _ready():
	target = get_tree().current_scene.find_child("testTarget")


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
