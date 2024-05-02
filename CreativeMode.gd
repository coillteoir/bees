extends CharacterBody3D

const speed:float = 10
@export var cam_sensitivity:int  = 100
var controlling = true

var relative:Vector2 = Vector2.ZERO

func _input(event):
	if event is InputEventMouseMotion and controlling:
		relative = event.relative
	if event.is_action_pressed("ui_cancel"):
		if controlling:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:			
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		controlling = ! controlling


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.

@export var can_move:bool = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate(Vector3.DOWN, deg_to_rad(relative.x * deg_to_rad(cam_sensitivity) * delta))
	rotate(transform.basis.x,deg_to_rad(- relative.y * deg_to_rad(cam_sensitivity) * delta))
	relative = Vector2.ZERO
	if can_move:
		var v = Vector3.ZERO
		
		var mult = 1
		if Input.is_key_pressed(KEY_SHIFT):
			mult = 3
		
		var strafe = Input.get_axis("ui_left", "ui_right") - v.x	
		if abs(strafe) > 0:   
			position = position + global_transform.basis.x * speed * strafe * mult * delta
			# global_translate(global_transform.basis.x * speed * turn * mult * delta)
		
		var move = Input.get_axis("ui_up", "ui_down")
		if abs(move) > 0:     
			global_translate(global_transform.basis.z * speed * move * mult * delta)
		
		var height = Input.get_axis("ascend", "descend")
		if abs(height) > 0:     
			global_translate(- global_transform.basis.y * speed * height * mult * delta)
