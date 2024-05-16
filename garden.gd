extends Node3D

const patch_marker: PackedScene = preload("res://patch_marker.tscn")
const flower_template: PackedScene = preload("res://flower.tscn")

# Defines the minimum distance between flowers.
const flower_min_distance: int = 7
# Defines the maximum amount of flowers per patch.
const max_flowers_per_patch: int = 10
# Defines the radius around the patch center flowers may spawn.
const flower_area: int = 12
# Defines the minimum distance between patches.
const patch_min_distance: int = 35
# Defines the radius around the buffer where no patches will spawn.
const hive_buffer: int = 20

var patch_flowers: Array = []
var patch_points: Array = []

# Defines the number of patches to spawn.
@export var patch_count: int = 15

# Defines the max distance from the hive that a patch can be.
var patch_area: float = hive_buffer + flower_area


func _init():
	#for i in range(15):
	#var patch_mesh = patch_marker.instantiate()
	#add_child(patch_mesh)
	#patch_mesh.global_position.x = i
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
		if new_point.distance_to(existing_point) < patch_min_distance:
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
	var fail_count = 0
	while patch_points.size() < patch_count:
		if fail_count == 20:
			patch_area += 5
			fail_count = 0
			print("INCREASING PATCH AREA")

		var patch_point = Vector2(
			randf_range(-patch_area, patch_area), randf_range(-patch_area, patch_area)
		)

		# Check if the new point is at least min_distance_origin away from the origin (0, 0)
		if !validate_patch_point(patch_point) or patch_point.length() < hive_buffer:
			fail_count += 1
			continue

		patch_points.append(patch_point)
		print("PATCH POINT")
		print(patch_point)

		##Testing patch spawns
		#var patch_mesh = patch_marker.instantiate()
		#add_child(patch_mesh)
		#patch_mesh.global_position.x = patch_point.x
		#patch_mesh.global_position.z = patch_point.y

		var num_flowers = randi_range(max_flowers_per_patch / 2, max_flowers_per_patch)
		#print("NUM FLOWERS")
		#print(num_flowers)

		patch_flowers.append([])

		while patch_flowers[-1].size() < num_flowers:
			var flower_point = Vector2(
				randf_range(patch_points[-1].x - (flower_area), patch_points[-1].x + (flower_area)),
				randf_range(patch_points[-1].y - (flower_area), patch_points[-1].y + (flower_area))
			)
			#print("FLOWER POINT")
			#print(flower_point)

			# Check if the new point is at least min_distance_origin away from the origin (0, 0)
			if !validate_flower_point(flower_point):
				print("FLOWER INVALID")
				continue

			var new_flower = flower_template.instantiate()
			add_child(new_flower)
			patch_flowers[-1].append(new_flower)

			patch_flowers[-1][-1].global_position.x = flower_point.x
			patch_flowers[-1][-1].global_position.z = flower_point.y
