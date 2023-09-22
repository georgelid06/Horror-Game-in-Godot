extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 4.0  # movement speed
var jump_speed = 6.0  # determines jump height
var mouse_sensitivity = 0.005  # turning speed

var flashlightPowerBar
var maxPower = 60
var rechargeTime = 10  # Time in seconds to fully recharge the flashlight.

func get_input():
	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	flashlightPowerBar = $/root/World/Control/Flashlight
	flashlightPowerBar.value = 1.0

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

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
	
func _process(delta):
	if Input.is_action_pressed("flashlight_button"):
		if flashlightPowerBar.value > 0.0:
			flashlightPowerBar.value -= delta / maxPower
	else:
		if flashlightPowerBar.value < 1.0:
			flashlightPowerBar.value += delta / rechargeTime

	
	
