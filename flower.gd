extends Node3D

var pollinated = true


func _ready():
	pass


func _process(delta):
	pass


func is_pollinated() -> bool:
	return pollinated


func set_pollinated(state: bool):
	pollinated = state


func _on_timer_timeout():
	pollinated = true
	print("Flower is pollinated")
