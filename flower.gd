extends Node3D

var pollinated = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func is_pollinated() -> bool:
	return pollinated

func set_pollinated(state:bool):
	pollinated = state

func _on_timer_timeout():
	pollinated = true
	print("Flower is pollinated")
	print(pollinated)
