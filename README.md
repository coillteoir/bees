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

# Controls
Once you enter the simulation, there is a fixed camera above the scene.
To explore the garden yourself, press enter. This will change to a first person camera.

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

# References
[Skybox](https://github.com/rpgwhitelock/AllSkyFree_Godot)
[BGM](https://youtu.be/_KwOh88Z-VI?si=dWQHKlkrpT146FG7)

Subversions denote milestones in the project, each of these must meet a level of acceptance criteria.

## V0.1
- Boid behaviour between bees
- - Flocking
- - Avoidance
- Spawning from hive
- Fixed Camera
- Spawning flowers on init

## V0.2
- Tracking flowers, and taking stuff to hive
- Hive level awareness of flowers
- Creative mode camera
- Bee tracking

## V0.3
- Manage flower resource and pollen replenishment
- Patches of flowers (collections of flowers)
- Bee POV

## V0.4
- When it rains they go back to hive
- Nuke button

# Subversion Acceptance Criteria
- Each proposed feature implemented
- Graphical fidelity up to high standard for features
- UI/Editor Exports allows decent control over features
- CI passing

# Features implemented
- Spawning flowers on init
- - "flower_count" decides the number of flower that should be spawned.
- - Flower coordinates are generated with at least "flower_min_distance" away from eachother
- - Flower coordinates are generated within a bounding area "flower_area"
- - Flower coordinates are generated with at least "flower_hive_distance" away from the origin (0,0)
- - Flowers spawn with randomly selected colours.
- Flowers manage their own resources, and replenish pollen periodically.
- Bees retrieve pollen from flowers, and bring pollen back to the hive.
- Fixed and dynamic camera using 3D character controller.


- Custom Hive, Bee and Flower meshes
- - All custom made in blender v3.6


