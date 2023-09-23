extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 4.0  # movement speed
var jump_speed = 6.0  # determines jump height
var mouse_sensitivity = 0.005  # turning speed

#flashlight variables
var flashlightPowerBar
var maxPower = 50
var isFlashlightOn = false
var spotlight
var isFlashlightDrained = false

func get_input():
	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	spotlight = $/root/World/CharacterBody3D/Camera3D/SpotLight3D
	flashlightPowerBar = $/root/World/Control/Flashlight
	flashlightPowerBar.value = maxPower

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_action_pressed("flashlight_button") and isFlashlightDrained == false:
		isFlashlightOn = not isFlashlightOn
		$/root/World/CharacterBody3D/working_flashlight.play()
	if event.is_action_pressed("flashlight_button") and isFlashlightDrained == true:
		$/root/World/CharacterBody3D/notworking_flashlight.play()

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))

	if event.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
	if event.is_action_pressed("click"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	velocity.y += -gravity * delta
	get_input()
	move_and_slide()
	spotlight.visible = isFlashlightOn

func _on_timer_timeout():
	if isFlashlightOn == true:
		flashlightPowerBar.value -= 1
	if flashlightPowerBar.value == 0:
		await get_tree().create_timer(0.2).timeout
		isFlashlightDrained = true
		isFlashlightOn = false
		

func _on_timer_2_timeout():
	if isFlashlightDrained == true:
		flashlightPowerBar.value += 1
		flashlightPowerBar.modulate = Color(1, 0.843137, 0, 1)
	if flashlightPowerBar.value == maxPower:
		isFlashlightDrained = false
		flashlightPowerBar.modulate = Color(0.972549, 0.972549, 1, 1)
