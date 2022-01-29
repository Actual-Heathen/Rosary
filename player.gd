extends KinematicBody

export var speed = 15
export var mSpeed = 5
export var isMonster = false;
var velocity = Vector3.ZERO
export var speedLock = 0
export var boost = 10
export var fall_acceleration = 98
var direction = Vector3.ZERO

func _physics_process(delta):
	
	
	if Input.is_action_pressed("right"):
		direction.x -= 1
	elif Input.is_action_pressed("left"):
		direction.x +=1
	if Input.is_action_pressed(("forward")):
		direction.z += 1
	elif Input.is_action_pressed("back"):
		direction.z -= 1
		

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(translation + direction, Vector3.UP)

	if !isMonster:
		
		if Input.is_action_just_pressed("boost") && direction != Vector3.ZERO:
			velocity.x = direction.x*speed*boost
			velocity.z = direction.z*speed*boost
		else:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
	else:
		if Input.is_action_just_pressed("boost") && direction != Vector3.ZERO:
			velocity.x = direction.x*mSpeed*boost
			velocity.z = direction.z*mSpeed*boost
		else:
			velocity.x = direction.x * mSpeed
			velocity.z = direction.z * mSpeed
			
	velocity = move_and_slide(velocity, Vector3.UP)
	
	if Input.is_action_just_pressed("monster"):
		isMonster = !isMonster
		
	#Vertical velocity
	velocity.y -= fall_acceleration * delta
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
