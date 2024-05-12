extends CharacterBody3D

var wingLeft: MeshInstance3D
var wingRight: MeshInstance3D

const LOW_ROTATION = -1
const HIGH_ROTATION = 1
const WING_SPEED = 0.1
var flappingUp = true
var wingRotation = 0


func _ready():
	#Setup wings
	wingLeft = get_node("Bee Model/wingLeft")
	wingRight = get_node("Bee Model/wingRight")
	
	wingLeft.rotate_z(-0.75)	
	wingLeft.global_position.y += tan(-0.75) * 0.1

func _on_timer_timeout():
	if(flappingUp): 		
		wingRotation += WING_SPEED		
		wingLeft.rotate_z(WING_SPEED)
		wingLeft.global_position.y += tan(WING_SPEED) * 0.15
		print(wingRotation)
		if (wingRotation >= 1.5):
			print("Changing to Down")
			wingRotation = 0
			flappingUp = false
	else: #Flapping down
		wingRotation += WING_SPEED
		wingLeft.rotate_z(-WING_SPEED)
		wingLeft.global_position.y += tan(-WING_SPEED) * 0.15
		print(wingRotation)
		if (wingRotation >= 1.5):
			print("Changing to Up")
			wingRotation = 0
			flappingUp = true


func _physics_process(delta):
	"""
	if(flappingUp): 
		wingRotation += WING_SPEED
		wingLeft.rotate_z(WING_SPEED)
		wingLeft.global_position.y += tan(WING_SPEED) * 0.1
		print(wingRotation)
		if (wingRotation >= HIGH_ROTATION):
			wingLeft.global_position.y = 0
			wingRotation = 0
			flappingUp == false
	else: #Flapping down
		wingRotation -= WING_SPEED
		wingLeft.rotate_z(WING_SPEED)
		wingLeft.global_position.y -= tan(WING_SPEED) * 0.1
		print(wingRotation)
		if (wingRotation <= LOW_ROTATION):
			wingLeft.global_position.y = 0
			wingRotation = 0
			flappingUp == true
	"""
