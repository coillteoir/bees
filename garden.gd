extends Node3D

# Defines the number of patches to spawn.
@export var patch_count: int = 15


class Patch:
	var point: Vector2
	var flowers: Array


# Defines the minimum distance between flowers.
const flower_min_distance: int = 7
# Defines the maximum amount of flowers per patch.
const max_flowers_per_patch: int = 10
# Defines the radius around the patch center flowers may spawn.
const flower_area: int = 12
# Defines the minimum distance between patches.
const patch_min_distance: int = 35
# Defines the radius around the hive where no patches will spawn.
const hive_buffer: int = 20

var patches: Array = []

# Defines the max distance from the hive that a patch can be.
var patch_area: float = hive_buffer + flower_area

const flower_template: PackedScene = preload("res://flower.tscn")

const colors: Array = [
	# Blue
	Color(0.125, 0.698, 0.666),
	# Yellow
	Color(1, 1, 0),
	# Pink
	Color(1, 0.713, 0.756),
	# Red
	Color(1, 0.27, 0),
]


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
		if new_point.distance_to(patch.point) < patch_min_distance:
			return false
	return true


func validate_flower_point(new_point, new_flowers):
	# Check if the new point is at least min_distance away from existing points
	for flower in new_flowers:
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
		if !validate_patch_point(patch.point) or patch.point.length() < hive_buffer:
			fail_count += 1
			continue

		var num_flowers: int = randi_range(max_flowers_per_patch / 2, max_flowers_per_patch)
		patch.flowers = []
		while patch.flowers.size() < num_flowers:
			var flower_point: Vector2 = Vector2(
				randf_range(patch.point.x - (flower_area), patch.point.x + (flower_area)),
				randf_range(patch.point.y - (flower_area), patch.point.y + (flower_area))
			)

			# Check if the new point is at least min_distance_origin away from the origin (0, 0)
			if !validate_flower_point(flower_point, patch.flowers):
				continue

			var new_flower = flower_template.instantiate()
			add_child(new_flower)
			new_flower.global_position.x = flower_point.x
			new_flower.global_position.z = flower_point.y
			new_flower.global_position.y = randf_range(-2, 0)

			var material = new_flower.get_node("Petals").get_active_material(0).duplicate()
			var color = colors[randi_range(0, colors.size() - 1)]
			print(color)
			material.albedo_color = color
			print(material.albedo_color)
			new_flower.get_node("Petals").set_surface_override_material(0, material)
			patch.flowers.append(new_flower)
		patches.append(patch)
		fail_count = 0
