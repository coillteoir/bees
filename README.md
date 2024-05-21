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

### Banking

### Wing Animation
Every frame the wings of the bee are animated in accordance with how fast the bee is moving.
The angle that a bee's wings will rotate each frame is calculated based off the acceleration force being applied to the bee boid. The wings will be rotated downwards until a max rotation is reached, then the wings will be rotated upwards. This is repeated to give the flapping motion seen.


# List of classes/assets

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



