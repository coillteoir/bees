extends Node3D

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
	if Input.is_action_just_pressed("music_enable"):
		$BGM.stream_paused = !$BGM.stream_paused

	if $HUD/VBoxContainer/bee_count.value != $Hive.max_bees:
		print("RECONCILING bees:", $HUD/VBoxContainer/bee_count.value)
		$Hive.max_bees = $HUD/VBoxContainer/bee_count.value
	if $HUD/VBoxContainer/flower_count.value != $Garden.patch_count:
		print("RECONCILING flowers:", $HUD/VBoxContainer/flower_count.value)
		$Garden.patch_count = $HUD/VBoxContainer/flower_count.value
	if Input.is_action_just_pressed("music_enable"):
		$BGM.stream_paused = !$BGM.stream_paused
