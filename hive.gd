extends Node3D

@export var BEES_MAX = 10

var bee = preload("res://bee.tscn")
var bees: Array = []


func _init():
	pass


func _spawn_bee():
	if bees.size() < BEES_MAX:
		var bee_n = bee.instantiate()
		bee_n.global_position.z += 1
		bee_n.velocity.x = randf_range(-10, 10)
		bee_n.velocity.y = randf_range(-10, 10)
		add_child(bee_n)
		bees.append(bee_n)


func _on_timer_timeout():
	_spawn_bee()


func _ready():
	pass


func _process(_delta):
	pass


func _on_area_3d_area_entered(area: Area3D):
	print("ENTERED")
	print(area.get_parent())
	bees = bees.filter(func(bee): bee != area.get_parent())
	remove_child(area.get_parent())
