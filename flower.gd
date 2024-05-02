extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	$flowerAttraction.set_monitoring(true)
	$flowerAttraction.set_monitorable(true)
	print("Flower is pollinated")


func _on_flower_attraction_area_entered(area):
	if area.name == "Bee Area":
		print("Pollen Taken")
		$flowerAttraction.set_monitorable(false)
		print($flowerAttraction.monitorable)
		$flowerAttraction/Timer.start()
