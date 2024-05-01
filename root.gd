extends Node3D

const flowers_count: int = 5
const MAG: int = 1
var flower_template: PackedScene = preload("res://flower.tscn")
var flowers: Array = []


func _init():
	for i in range(flowers_count):
		var new_flower = flower_template.instantiate()

		flowers.append(new_flower)
		add_child(new_flower)


func _ready():
	for i in range(flowers.size()):
		flowers[i].global_position.x = MAG * cos(i * TAU / flowers_count)
		flowers[i].global_position.z = randf_range(-MAG, MAG)
		flowers[i].global_position.y = MAG * sin(i * TAU / flowers_count)
