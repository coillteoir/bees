extends CharacterBody3D

const SPEED: float = 10
@export var cam_sensitivity: int = 100
var relative: Vector2 = Vector2.ZERO


func _input(event):
	if event is InputEventMouseMotion:
		relative = event.relative


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	rotate(Vector3.DOWN, deg_to_rad(relative.x * deg_to_rad(cam_sensitivity) * delta))
	rotate(transform.basis.x, deg_to_rad(-relative.y * deg_to_rad(cam_sensitivity) * delta))
	relative = Vector2.ZERO

	var mult = 1
	if Input.is_key_pressed(KEY_SHIFT):
		mult = 3

	var strafe = Input.get_axis("ui_left", "ui_right")
	if abs(strafe) > 0:
		position = position + global_transform.basis.x * SPEED * strafe * mult * delta
		# global_translate(global_transform.basis.x * speed * turn * mult * delta)

	var move = Input.get_axis("ui_up", "ui_down")
	if abs(move) > 0:
		global_translate(global_transform.basis.z * SPEED * move * mult * delta)

	var height = Input.get_axis("ascend", "descend")
	if abs(height) > 0:
		global_translate(-global_transform.basis.y * SPEED * height * mult * delta)
