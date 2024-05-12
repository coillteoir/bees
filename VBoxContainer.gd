extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$bee_label.text = "Bees: %s" % $bee_count.value
	$flower_label.text = "Flowers: %s" % $flower_count.value
