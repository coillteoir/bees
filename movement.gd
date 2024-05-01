extends CharacterBody3D

const SPEED = 1
@export var forward: bool = true
@export var closest: bool = true

var movements: Array[Callable] = []

# SEEK_FLOWER_CHANCE = FOUND_FLOWERS/TOTAL_FLOWERS
func _avoid() -> Vector3:
	return Vector3(0,0,0)

func _seek() -> Vector3:
	return Vector3(0,0,0)

func _wander() -> Vector3:
	return Vector3(0,0,0)

func _closest_flower() -> Vector3:
	return Vector3(0, 0, 0)


func _forward() -> Vector3:
	return Vector3(0, 0, SPEED)


func _init():
	if forward:
		movements.append(_forward)
	if closest:
		movements.append(_closest_flower)


func _physics_process(delta):
	var vel: Vector3 = Vector3(0, 0, 0)
	for i in range(movements.size()):
		vel += movements[i].call()
	velocity = vel
	move_and_slide()
