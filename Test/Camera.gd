extends Camera

export var rotation_sensitivity = 30
export var speed = 20

# Rotation
var rot_x: float = 0
var rot_y: float = 0

func _ready():
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	var velocity = Vector3()
	if Input.is_action_pressed("forward"):
		velocity.z -= 1
	if Input.is_action_pressed("back"):
		velocity.z += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("right"):
		velocity.x += 1

	translate(velocity)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

	if event is InputEventMouseMotion:
		var x = event.relative.x
		var y = event.relative.y
		rot_x -= x / rotation_sensitivity
		rot_y -= y / rotation_sensitivity
		rot_y = clamp(rot_y, deg2rad(-90), deg2rad(90))
		transform.basis = Basis()
		rotate_object_local(Vector3.UP, rot_x)
		rotate_object_local(Vector3.RIGHT, rot_y)
