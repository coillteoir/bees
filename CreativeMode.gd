extends CharacterBody3D


const speed:float = 10
@export var cam_sensitivity:int  = 100
var relative

func _input(event):
	if event is InputEventMouseMotion:
		relative = event.relative

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate(Vector3.DOWN, deg_to_rad(relative.x * deg_to_rad(cam_sensitivity) * delta))
	rotate(transform.basis.x,deg_to_rad(- relative.y * deg_to_rad(cam_sensitivity) * delta))
	relative = Vector2.ZERO
	
	var mult = 1
	if Input.is_key_pressed(KEY_SHIFT):
		mult = 3
	
	var strafe = Input.get_axis("ui_left", "ui_right")	
	if abs(strafe) > 0:   
		position = position + global_transform.basis.x * speed * strafe * mult * delta
		# global_translate(global_transform.basis.x * speed * turn * mult * delta)
	
	var move = Input.get_axis("ui_up", "ui_down")
	if abs(move) > 0:     
		global_translate(global_transform.basis.z * speed * move * mult * delta)
	
	var height = Input.get_axis("ascend", "descend")
	if abs(height) > 0:     
		global_translate(- global_transform.basis.y * speed * height * mult * delta)
