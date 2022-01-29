extends KinematicBody

export var speed = 20
export var mSpeed = 15
export var isMonster = false;
var velocity = Vector3.ZERO
export var boost = 10
var fall_acceleration = 98
export var direction = Vector3.ZERO

var dust = preload("res://prefabs/dashparticle.tscn")

func _physics_process(delta):
	var dust_instance = dust.instance()
	
	direction = Vector3.ZERO
	
	if Input.is_action_pressed("right"):
		direction.x -= 1
	elif Input.is_action_pressed("left"):
		direction.x +=1
	if Input.is_action_pressed(("forward")):
		direction.z += 1
	elif Input.is_action_pressed("back"):
		direction.z -= 1
	
	if direction.x == -1:
		if direction.z == -1:
			dust_instance.rotate_y(45)
		elif direction.z == 1:
			dust_instance.rotate_y(90)
		else:
			dust_instance.rotate_y(-67.5)
	
	dust_instance.translation = translation 
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(translation + direction, Vector3.UP)
	
	
	
	if !isMonster:
		
		if Input.is_action_just_pressed("boost") && direction != Vector3.ZERO:
			velocity.x = direction.x*speed*boost
			velocity.z = direction.z*speed*boost
			get_parent().add_child(dust_instance)
		else:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
	else:
		if Input.is_action_just_pressed("boost") && direction != Vector3.ZERO:
			velocity.x = direction.x*mSpeed*boost
			velocity.z = direction.z*mSpeed*boost
			get_parent().add_child(dust_instance)
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
