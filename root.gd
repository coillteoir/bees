extends Node3D

@export var flower_area: int = 15
@export var flower_min_distance: int = 5
@export var flower_hive_distance: int = 10

var camera_mode = 0


func _init():
	pass


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _process(_delta):
	# Manage creative mode state
	if Input.is_action_just_pressed("ui_text_clear_carets_and_selection"):
		get_tree().quit()
	if Input.is_action_just_pressed("change_cam"):
		print("camera change")
		camera_mode = (camera_mode + 1) % 2
		match camera_mode:
			0:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				find_child("FixedCamera").current = true
			1:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				find_child("CreativeMode").find_child("Camera3D").current = true
	if $HUD/VBoxContainer/bee_count.value != $Hive.BEES_MAX:
		print("RECONCILING bees:", $HUD/VBoxContainer/bee_count.value)
		$Hive.BEES_MAX = $HUD/VBoxContainer/bee_count.value
	if $HUD/VBoxContainer/flower_count.value != $Garden.flower_count:
		print("RECONCILING flowers:", $HUD/VBoxContainer/flower_count.value)
		$Garden.flower_count = $HUD/VBoxContainer/flower_count.value
	if Input.is_action_just_pressed("music_enable"):
		$BGM.stream_paused = !$BGM.stream_paused
