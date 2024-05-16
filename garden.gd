extends Node3D


class Patch:
	var point: Vector2
	var flowers: Array


const FLOWER_MIN_DISTANCE: int = 7

const MAX_FLOWERS_PER_PATCH: int = 10
# the radius around the patch center flowers may spawn.
const FLOWER_AREA: int = 12
# minimum distance between patches.
const PATCH_MIN_DISTANCE: int = 35
# radius around the buffer where no patches will spawn.
const HIVE_BUFFER: int = 20

const FLOWER_TEMPLATE: PackedScene = preload("res://flower.tscn")

const COLORS: Array = [
	# Blue
	Color(0.125, 0.698, 0.666),
	# Yellow
	Color(1, 1, 0),
	# Pink
	Color(1, 0.713, 0.756),
	# Red
	Color(1, 0.27, 0),
]

var patch_count: int = 15
var patches: Array = []
var patch_area: float = HIVE_BUFFER + FLOWER_AREA


func _init():
	pass


func _ready():
	generate_flower_patches()


func _process(_delta):
	if patch_count > patches.size():
		generate_flower_patches()
	if patch_count < patches.size():
		var delete_index = randi_range(0, patches.size() - 1)
		if patches.size() != 0:
			for item in patches[delete_index].flowers:
				item.queue_free()
			patches.erase(patches[delete_index])


func validate_patch_point(new_point):
	# Check if the new point is at least min_distance away from existing points
	for patch in patches:
		if new_point.distance_to(patch.point) < PATCH_MIN_DISTANCE:
			return false
	return true


func validate_flower_point(new_point, new_flowers):
	# Check if the new point is at least min_distance away from existing points
	for flower in new_flowers:
		if (
			new_point.distance_to(Vector2(flower.global_position.x, flower.global_position.z))
			< FLOWER_MIN_DISTANCE
		):
			return false
	return true


# Function to generate flowers coordinates
# Flower coordinates are generated with at least "FLOWER_MIN_DISTANCE" away from eachother
# Flower coordinates are generated within a bounding area "FLOWER_AREA"
# Flower coordinates are generated with at least "flower_hive_distance" away from the origin (0,0)
func generate_flower_patches():
	var fail_count = 0
	while patches.size() < patch_count:
		var patch = Patch.new()
		if fail_count == 20:
			patch_area += 5
			fail_count = 0
			print("INCREASING PATCH AREA")

		patch.point = Vector2(
			randf_range(-patch_area, patch_area), randf_range(-patch_area, patch_area)
		)

		# Check if the new point is at least min_distance_origin away from the origin (0, 0)
		if !validate_patch_point(patch.point) or patch.point.length() < HIVE_BUFFER:
			fail_count += 1
			continue

		var num_flowers: int = randi_range(MAX_FLOWERS_PER_PATCH / 2, MAX_FLOWERS_PER_PATCH)
		patch.flowers = []
		while patch.flowers.size() < num_flowers:
			var flower_point: Vector2 = Vector2(
				randf_range(patch.point.x - (FLOWER_AREA), patch.point.x + (FLOWER_AREA)),
				randf_range(patch.point.y - (FLOWER_AREA), patch.point.y + (FLOWER_AREA))
			)

			# Check if the new point is at least min_distance_origin away from the origin (0, 0)
			if !validate_flower_point(flower_point, patch.flowers):
				continue

			var new_flower = FLOWER_TEMPLATE.instantiate()
			add_child(new_flower)
			new_flower.global_position.x = flower_point.x
			new_flower.global_position.z = flower_point.y
			new_flower.global_position.y = randi_range(0, 5)

			var material = new_flower.get_node("Petals").get_active_material(0).duplicate()
			var color = COLORS.pick_random()
			print(color)
			material.albedo_color = color
			print(material.albedo_color)
			new_flower.get_node("Petals").set_surface_override_material(0, material)
			patch.flowers.append(new_flower)

		patches.append(patch)
		fail_count = 0
