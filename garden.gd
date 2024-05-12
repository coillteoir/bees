extends Node3D

@export var patch_count: int = 1

#Defines the maximum amount of 
var max_flowers_per_patch: int = 7

# Defines the minimum distance between flowers
var flower_min_distance: int = 6

# Defines the area of patches and the distance between them
var flower_area: float = sqrt(max_flowers_per_patch * flower_min_distance) * 3

var hive_buffer: int = 40

# Defines the area that patches are enclosed in
var patch_area: int = (flower_area * 2 ) * patch_count

var patch_flowers: Array = []
var patch_points: Array = []

var flower_template: PackedScene = preload("res://flower.tscn")


func _init():
	pass


func _ready():
	print("FLOWER AREA")
	print(flower_area)
	print("PATCH AREA")
	print(patch_area)
	generate_flower_patches()


func _process(_delta):
	#if flower_count > flowers.size():
		#generate_flower()
	#if flower_count < flowers.size():
		#var toDelete = flowers.pick_random()
		#flowers.erase(toDelete)
		#toDelete.queue_free()
	pass


func validate_patch_point(new_point):
	# Check if the new point is at least min_distance away from existing points
	for existing_point in patch_points:
		if new_point.distance_to(existing_point) < flower_min_distance:
			return false
	return true


func validate_flower_point(new_point):
	# Check if the new point is at least min_distance away from existing points
	for flower in patch_flowers[-1]:
		if new_point.distance_to(Vector2(flower.global_position.x, flower.global_position.z)) < flower_min_distance:
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
		if !validate_patch_point(patch_point) and patch_point.length() < patch_area and patch_point.length() > flower_area:
			continue

		patch_points.append(patch_point)
		print("PATCH POINT")
		print(patch_point)
		
		var num_flowers = randi_range(max_flowers_per_patch/2, max_flowers_per_patch)
		print("NUM FLOWERS")
		print(num_flowers)
		
		patch_flowers.append([])
		
		while patch_flowers[-1].size() < num_flowers:
			var flower_point = Vector2(
				randf_range(patch_points[-1].x - (flower_area/2), patch_points[-1].y + (flower_area/2)),
				randf_range(patch_points[-1].x - (flower_area/2), patch_points[-1].y + (flower_area/2))
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
