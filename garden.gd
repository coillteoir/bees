extends Node3D

@export var flower_area: int = 2
@export var flower_min_distance: int = 5
@export var flower_hive_distance: int = 10

var flower_template: PackedScene = preload("res://flower.tscn")
var flowers: Array = []

var flower_count: int = 10


func _init():
	pass


func _ready():
	for i in range(flower_count):
		generate_flower()


func _process(_delta):
	if flower_count > flowers.size():
		generate_flower()
	if flower_count < flowers.size():
		var toDelete = flowers.pick_random()
		flowers.erase(toDelete)
		toDelete.queue_free()


func validate_point(point: Vector2) -> bool:
	for flower in flowers:
		var current_point = Vector2(flower.global_position.x, flower.global_position.z)
		if current_point.distance_to(point) < flower_min_distance:
			return false
	return true


# Function to generate flowers coordinates
# Flower coordinates are generated with at least "flower_min_distance" away from eachother
# Flower coordinates are generated within a bounding area "flower_area"
# Flower coordinates are generated with at least "flower_hive_distance" away from the origin (0,0)
func generate_flower():
	var new_flower = flower_template.instantiate()
	var new_point = Vector2(
		randf_range(-flower_area * flower_count, flower_area * flower_count),
		randf_range(-flower_area * flower_count, flower_area * flower_count)
	)
	var retries = 0
	while !validate_point(new_point) && retries < 5:
		new_point = Vector2(
			randf_range(-flower_area * flower_count, flower_area * flower_count),
			randf_range(-flower_area * flower_count, flower_area * flower_count)
		)

	add_child(new_flower)
	new_flower.global_position.x = new_point.x
	new_flower.global_position.z = new_point.y
	flowers.append(new_flower)
