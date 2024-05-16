# Bees

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
|SHIFT|Down|

# References
|Resource|Source|
|--|--|
|Skybox|https://github.com/rpgwhitelock/AllSkyFree_Godot|
|BGM|https://youtu.be/_KwOh88Z-VI?si=dWQHKlkrpT146FG7|

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

# Completed
- Spawning flowers on init
- - "flower_count" decides the number of flower that should be spawned.
- - Flower coordinates are generated with at least "flower_min_distance" away from eachother
- - Flower coordinates are generated within a bounding area "flower_area"
- - Flower coordinates are generated with at least "flower_hive_distance" away from the origin (0,0)

- Custom Hive & Bee meshes
- - Both meshes custom made in blender v3.6
