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
## Camera Controls
The camera view can be switched between a fixed camera and a first person “Creative Mode” camera. The root script cycles through each of these when the ALT key is pressed.

The first person “CreativeMode” camera is attached to a CharacterBody3D. This has a script attached to respond accordingly to WASD movement and mouse control.

## Garden

## Flower

## Hive
There is a timer attached to the hive, and when it times out a bee will be spawned. A reference to this bee is added to an array to keep track. Bees will be spawned up to a maximum limit, which is set using the UI sliders.

When a bee comes in contact with the hive, they “enter”. The bee is despawned and its reference is removed from the bee array.

## Bee
### Beehavior
When the bees are first spawned, they implement a “noise wander” boid behavior, where their movements are determined by random points. Each flower has a sphere around it called the “Attraction Sphere”. When a bee enters this and the flower has pollen, the bee will change its behavior to arrive, making a beeline to the center of the flower.

When the bee enters the pollen (center of the flower), its behavior will be set to arrive with the hive as the target, as the bee returns with its collected pollen. Yellow particles will be applied to the bee to signify that it is carrying pollen.

When the bee makes contact with the hive, the hive will despawn the bee.

If the bee's distance from the hive ever eclipses the MAX_DIST_FROM_HIVE constant, the bee will enter the arrive behavior with the target set to hive.

### Banking

### Wing Animation
Every frame the wings of the bee are animated in accordance with how fast the bee is moving.
The angle that a bee's wings will rotate each frame is calculated based off the acceleration force being applied to the bee boid. The wings will be rotated downwards until a max rotation is reached, then the wings will be rotated upwards. This is repeated to give the flapping motion seen.


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
## Luke Moss Hughes (C20487654)
### What I Did

### What I am Most Proud Of

### What I Learned

## James Clarke (C20375736)
### What I Did
My main contribution was implementing the majority of the bee behavior. This includes the noise wander and arrive implementations, the logic for encountering a flower, and the wing animation.

### What I am Most Proud Of
I am most proud of creating a bee creature that closely mimics the behaviors of real life bees. 

### What I Learned
I learned a lot about boid behaviors, and how to implement them in different contexts to create realistic and lifelike behaviors. 

## David Lynch (C19500876)
### What I Did
I set up the repo and instructed my teammates on how to employ continuous integration in the project. This was chosen instead of feature branching since it leads to smaller merges and each team member will be merging to the same branch continually. I set up automation using GitHub actions for the project to automate code quality checks.

I implemented the HUD, changing bee and flower counts with sliders,and created a simple version of creative mode controls which were eventually elaborated on by other teammates. 

I also implemented the hive spawning logic. 

### What I am Most Proud Of
I am proud of setting up continuous integration, and seeing the speed of features being implemented. I’m also proud of making the game respond to the HUD. 

### What I Learned
I learned how to effectively resolve merge conflicts with godot scenes, and how to manage loading and unloading scene instances.

# Project Planning
Before starting on the project, the features we wanted to achieve were defind, and sorted into stages of project

## V0.1
- Bee Wandering
- Beee spawning from hive
- Fixed Camera
- Spawning flowers on init

## V0.2
- Arriving to flowers, and taking nectar back to hive
- Creative mode camera

## V0.3
- Manage flower resource and pollen replenishment
- Patches of flowers (collections of flowers)

## Future Development
- Bee POV camera
- Hive memory of flowers that have been found (Some bees will then go directely from the hive to a found flower)
- When it rains bees go back to hive



