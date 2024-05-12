extends Node3D

@export var flower_area: int = 15
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
		

func validate_flower(new_flower) -> bool:
	return true


# Function to generate flowers coordinates
# Flower coordinates are generated with at least "flower_min_distance" away from eachother
# Flower coordinates are generated within a bounding area "flower_area"
# Flower coordinates are generated with at least "flower_hive_distance" away from the origin (0,0)
func generate_flower():
	var new_flower = flower_template.instantiate()
	add_child(new_flower)
	new_flower.global_position.x = randf_range(-flower_area, flower_area)
	new_flower.global_position.z = randf_range(-flower_area, flower_area)
	flowers.append(new_flower)
	
