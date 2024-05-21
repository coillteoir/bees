# Bees
## Group (The Bee Boys)
Name: Luke Moss Hughes

Student Number: C20487654


Name: James Clarke

Student Number: C20375736

Name: David Lynch

Student Number: C19500876

# Description

## Video
[![YouTube](https://i3.ytimg.com/vi/Sh4RQ2U0a24/maxresdefault.jpg)](https://youtu.be/Sh4RQ2U0a24)

## Screenshots

# Instructions
Once you enter the simulation, there is a fixed camera above the scene. Here you can edit the sliders to control variables in the simulation
To explore the garden yourself, press ALT. This will change to a first person camera.

## General
|Button|Movement|
|------|--------|
|ALT|Change Camera Mode|
|M|Toggle Music|

## "Creative Mode" Camera
|Button|Movement|
|----|----|
|A|Left|
|D|Right|
|W|Forward|
|S|Back|
|SPACE|Up|
|CTRL|Down|
|SHIFT|Fast Movement|

# How it works

# List of classes/assets
| Class Name | Description | Properties | Methods |
|:----:|:----:|:----:|:----:|
| root | The "root" class is responsible for toggling camera modes, updating values tied to hud sliders, and muting/unmuting music. | camera_mode: int - Holds state of camera. | _ready() - Sets mouse mode. |
|  |  |  | _process() - Monitors input events and HUD slider values, to respond appropriately. |
|||||
| hive | The "hive" class is responsible for spawning and destroying bees, when appropriate. | bees_max: int -  Bees will not be spawned beyond the value of "bees_max". | _spawn_bee() - If the number of instantiated bees is lower than "bees_max", this method spawns a new bee. |
|  |  | bee: PackedScene - Holds a PackedScene/Resource that points to bee.tscn. Used to instantiate bees. | _on_timer_timeout() - Triggered every 2.5 seconds by a timer, calls the _spawn_bee() function. |
|  |  | bees: Array - Holds all instances of bees. | _on_area_3d_area_entered(area: Area3D) - Used to detect when bees collide with the hive and call queue_free() to despawn and free the bee instance from memory. |
|||||
| bee | The "bee" class is a boid. Bee's arrive at the "exitPoint" of the hive after spawning. When a bee reaches the exit point it will start wandering. When they find a pollinated flower, they take the pollen and "arrive" at the hive. |  | _ready() - In this method, some variables are set and the bee is set to arrive at the "exitPoint" of the hive. |
|  |  |  | SetupWings() - This method stores the wings of the boid in variables and rotates them to their starting angle. |
|  |  |  | _physics_process(delta) -  This method runs 60 times per second. It calls the "animateWings", "applyForce", and "applyRotation" methods to make changes to the bee boid over time. It ensures bee return to the hive if they wander too far from it with "setStatusArrive(hive)" |
|  |  |  | animateWings() - This method is used to programmatically animate the wings of bee's. This approach was chosen over using an animatableBody3D, due to time constraints. |
|  |  |  | _arrive() - This method calculates the force applied to bees when arriving at a target. |
|  |  |  | _noiseWander() - This method calculates the force applied to bees when wandering. |
|  |  |  | setStatusArrive(target) - This method changes the boid behavior of a bee to "Arriving" at a target. |
|  |  |  | setStatusReturning(target) - This method changes the void behavior of a bee to "Returning" at a target. |
|  |  |  | setStatusWander() - This method changes the boid behavior of a bee to "Wandering". |
|  |  |  | calculate() - This method integrates the forces from each active boid behavior into an accumalated force, used to change the velocity of the bee. |
|  |  |  | applyForce(delta) - This method applies changes in force to the bee. |
|  |  |  | applyRotation(delta) - This method applies rotations to the pitch, yaw, and roll of the bee based on it's velocity. |
|  |  |  | _on_bee_area_entered(area: Area3D) - Used to detect when bees reach the "exitPoint" of the hive or enter the attraction sphere, or pollen sphere of flowers. When the exit point of the hive is reached, the bee's boid behavior is set to "Wandering". When the attraction sphere of a flower is entered, the bee's boid behavior is set to "Arriving" with the flower's pollen as it's target. When the pollen sphere of a flower is entered, the bee's boid behavior is set to "Returning" with the hive as it's target. |
|  |  |  |  |
| garden | The "garden" class is used to store data relating to flowers and flower patches, as well as dynamically spawning flowers and flower patches. | patch_count: int - Stores of the number of flower patches that should be instantiated. | _ready() - This method is used to initiate the generation of flower patches when the garden is instantiated. |

# Team Member Contributions





