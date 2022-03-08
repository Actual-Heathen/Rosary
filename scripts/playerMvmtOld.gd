extends KinematicBody

export var speed = 15
#export var acceleration = 20
var velocity = Vector3.ZERO
export var speedLock = 0
export var boost = 10

func _physics_process(delta):
	
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("right"):
		direction.x -= 1
	if Input.is_action_pressed("left"):
		direction.x +=1
	if Input.is_action_pressed(("forward")):
		direction.z += 1
	if Input.is_action_pressed("back"):
		direction.z -= 1
		
	#if abs(velocity.x) <= 0 && abs(velocity.z) <= 0:
	#	speedLock = true
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(translation + direction, Vector3.UP)
	#if (abs(velocity.x) < speed && abs(velocity.z) < speed) && speedLock:
	#	velocity.x += acceleration*delta*direction.x
	#	velocity.z += acceleration*delta*direction.z
		
		print(velocity.x)
	
	if Input.is_action_just_pressed("boost") && direction != Vector3.ZERO:
		velocity.x = direction.x*speed*boost
		velocity.z = direction.z*speed*boost
	else:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	# Vertical velocity
	#velocity.y -= fall_acceleration * delta ##unused##
	# Moving the character
	velocity = move_and_slide(velocity, Vector3.UP)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
