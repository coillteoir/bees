extends Node3D

var pollination = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func is_pollinated() -> bool:
	return pollination


func set_pollination(state: bool):
	pollination = state
	update_particles()
	if !state:
		get_node("Timer").start()


func update_particles():
	var pollen_particles = get_node("GPUParticles3D")

	# Emit pollen particles if flower is pollinated
	pollen_particles.emitting = pollination


func _on_timer_timeout():
	set_pollination(true)
	print("Flower is pollinated")
