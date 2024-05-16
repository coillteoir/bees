extends Node3D

@export var patch_count: int = 1

#Defines the maximum amount of
var max_flowers_per_patch: int = 7

# Defines the minimum distance between flowers
var flower_min_distance: int = 6

# Defines the area of patches and the distance between them
var flower_area: float = sqrt(max_flowers_per_patch * flower_min_distance) * 2.5

# Defines the area that patches are enclosed in
var patch_area: int = sqrt(flower_area * patch_count)

var patch_flowers: Array = []
var patch_points: Array = []

var flower_template: PackedScene = preload("res://flower.tscn")

var camera_mode = 0


func _init():
	pass


func _ready():
	generate_flower_patches()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _process(_delta):
	# Manage creative mode state
	if Input.is_action_just_pressed("ui_text_clear_carets_and_selection"):
		get_tree().quit()
i	if Input.is_action_just_pressed("change_cam"):
		print("camera change")
		camera_mode = (camera_mode + 1) % 2
		match camera_mode:
			0:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				find_child("FixedCamera").current = true
			1:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				find_child("CreativeMode").find_child("Camera3D").current = true
	if Input.is_action_just_pressed("music_enable"):
		$BGM.stream_paused = !$BGM.stream_paused

	if $HUD/VBoxContainer/bee_count.value != $Hive.BEES_MAX:
		print("RECONCILING bees:", $HUD/VBoxContainer/bee_count.value)
		$Hive.BEES_MAX = $HUD/VBoxContainer/bee_count.value
	if $HUD/VBoxContainer/flower_count.value != $Garden.flower_count:
		print("RECONCILING flowers:", $HUD/VBoxContainer/flower_count.value)
		$Garden.flower_count = $HUD/VBoxContainer/flower_count.value


func validate_patch_point(new_point):
	# Check if the new point is at least min_distance away from existing points
	for existing_point in patch_points:
		if new_point.distance_to(existing_point) < flower_min_distance:
			return false
	return true


func validate_flower_point(new_point):
	# Check if the new point is at least min_distance away from existing points
	for flower in patch_flowers[-1]:
		if (
			new_point.distance_to(Vector2(flower.global_position.x, flower.global_position.z))
			< flower_min_distance
		):
			return false
	return true


# Function to generate flowers coordinates
# Flower coordinates are generated with at least "flower_min_distance" away from eachother
# Flower coordinates are generated within a bounding area "flower_area"
# Flower coordinates are generated with at least "flower_hive_distance" away from the origin (0,0)
func generate_flower_patches():
	while patch_points.size() < patch_count:
		var patch_point = Vector2(
			randf_range(-patch_area, patch_area), randf_range(-patch_area, patch_area)
		)

		# Check if the new point is at least min_distance_origin away from the origin (0, 0)
		if !validate_patch_point(patch_point) and patch_point.length() < 40:
			continue

		patch_points.append(patch_point)
		print("PATCH POINT")
		print(patch_point)

		var num_flowers = randi_range(max_flowers_per_patch / 2, max_flowers_per_patch)
		print("NUM FLOWERS")
		print(num_flowers)

		patch_flowers.append([])

		while patch_flowers[-1].size() < num_flowers:
			var flower_point = Vector2(
				randf_range(
					patch_points[-1].x - (flower_area / 2), patch_points[-1].y + (flower_area / 2)
				),
				randf_range(
					patch_points[-1].x - (flower_area / 2), patch_points[-1].y + (flower_area / 2)
				)
			)
			print("FLOWER POINT")
			print(flower_point)

			# Check if the new point is at least min_distance_origin away from the origin (0, 0)
			if !validate_flower_point(flower_point):
				print("INVALID")
				continue
			print("VALID")

			var new_flower = flower_template.instantiate()
			add_child(new_flower)
			patch_flowers[-1].append(new_flower)

			patch_flowers[-1][-1].global_position.x = flower_point.x
			patch_flowers[-1][-1].global_position.z = flower_point.y
