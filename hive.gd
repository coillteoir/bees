extends Node3D

@export var BEES_MAX = 50

var bee = preload("res://bee.tscn")
var bees: Array = []


func _init():
	pass


func _spawn_bee():
	print(bees.size())
	if bees.size() < BEES_MAX:
		var bee_n = bee.instantiate()

		add_child(bee_n)
		bee_n.global_position.x += 2
		bee_n.global_position.y += 0.5
		bee_n.global_rotation.y = 90
		bees.append(bee_n)

func _on_timer_timeout():
	_spawn_bee()


func _ready():
	pass


func _process(_delta):
	pass


func _on_area_3d_area_entered(area: Area3D):
	var bee = area.get_parent()
	bees.erase(bee)
	remove_child(bee)
