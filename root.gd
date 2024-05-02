extends Node3D

@export var flower_count: int = 10
@export var flower_area: int = 15
@export var flower_min_distance: int = 5
@export var flower_hive_distance: int = 10

var flower_template: PackedScene = preload("res://flower.tscn")
var flowers: Array = []

var camera_mode = 0


func _init():
	for i in range(flower_count):
		var new_flower = flower_template.instantiate()
		flowers.append(new_flower)
		add_child(new_flower)


func _process(delta):
	# Manage creative mode state
	if Input.is_action_just_pressed("ui_text_clear_carets_and_selection"):
		get_tree().quit()
	if Input.is_action_just_pressed("ui_accept"):
		print("camera change")
		camera_mode = (camera_mode + 1) % 2
		match camera_mode:
			0:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				find_child("FixedCamera").current = true
			1:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				find_child("CreativeMode").find_child("Camera3D").current = true


func _ready():
	generate_flower_coords(flower_count, flower_min_distance, flower_area, flower_hive_distance)


# Function to generate flowers coordinates
# Flower coordinates are generated with at least "flower_min_distance" away from eachother
# Flower coordinates are generated within a bounding area "flower_area"
# Flower coordinates are generated with at least "flower_hive_distance" away from the origin (0,0)
func generate_flower_coords(
	flower_count: int, flower_min_distance: float, flower_area: int, flower_hive_distance: float
):
	var points = []
	while points.size() < flower_count:
		var new_point = Vector2(
			randf_range(-flower_area, flower_area), randf_range(-flower_area, flower_area)
		)

		# Check if the new point is at least min_distance_origin away from the origin (0, 0)
		if new_point.length() < flower_hive_distance:
			continue

		var valid = true

		# Check if the new point is at least min_distance away from existing points
		for existing_point in points:
			if new_point.distance_to(existing_point) < flower_min_distance:
				valid = false
				break

		# Add the new point if it's valid
		if valid:
			flowers[points.size()].global_position.x = new_point.x
			flowers[points.size()].global_position.z = new_point.y
			points.append(new_point)
