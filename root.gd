extends Node3D

@export var flower_area: int = 15
@export var flower_min_distance: int = 5
@export var flower_hive_distance: int = 10

var flower_template: PackedScene = preload("res://flower.tscn")
var flowers: Array = []

var camera_mode = 0
var flower_count = 10


func _init():
	for i in range(flower_count):
		var new_flower = flower_template.instantiate()
		flowers.append(new_flower)
		add_child(new_flower)


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	generate_flower_coords()


func _process(_delta):
	# Manage creative mode state
	if Input.is_action_just_pressed("ui_text_clear_carets_and_selection"):
		get_tree().quit()
	if Input.is_action_just_pressed("change_cam"):
		print("camera change")
		camera_mode = (camera_mode + 1) % 2
		match camera_mode:
			0:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				find_child("FixedCamera").current = true
			1:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				find_child("CreativeMode").find_child("Camera3D").current = true
	if $HUD/VBoxContainer/bee_count.value != $Hive.BEES_MAX:
		print("RECONCILING bees:", $HUD/VBoxContainer/bee_count.value)
		$Hive.BEES_MAX = $HUD/VBoxContainer/bee_count.value


func validate_point(new_point, points) -> bool:
	# Check if the new point is at least min_distance away from existing points
	for existing_point in points:
		if new_point.distance_to(existing_point) < flower_min_distance:
			return false
	return true


# Function to generate flowers coordinates
# Flower coordinates are generated with at least "flower_min_distance" away from eachother
# Flower coordinates are generated within a bounding area "flower_area"
# Flower coordinates are generated with at least "flower_hive_distance" away from the origin (0,0)
func generate_flower_coords():
	var points = []
	while points.size() < flower_count:
		var new_point = Vector2(
			randf_range(-flower_area, flower_area), randf_range(-flower_area, flower_area)
		)

		# Check if the new point is at least min_distance_origin away from the origin (0, 0)
		if !validate_point(new_point, points) and new_point.length() < flower_hive_distance:
			continue

		flowers[points.size()].global_position.x = new_point.x
		flowers[points.size()].global_position.z = new_point.y
		points.append(new_point)
