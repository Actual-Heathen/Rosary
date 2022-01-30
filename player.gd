extends KinematicBody

export var speed = 20
export var mSpeed = 15
export var isMonster = false
var velocity = Vector3.ZERO
export var boost = 10
export var fall_acceleration = 98
export var canMove = true
export var direction = Vector3.ZERO
export var maxDash = 3
var dashCount = 0;
var timerMax = 5
var timer = timerMax
var ticking = false
onready var sprite = $CSGMesh

var dust = preload("res://prefabs/dashparticle.tscn")

func _physics_process(delta):
	var dust_instance = dust.instance()
	velocity.y -= fall_acceleration * delta
	direction = Vector3.ZERO
	
	
	if Input.is_action_pressed(("forward")):
		direction.z += 1
		sprite.flip_h = false
	elif Input.is_action_pressed("back"):
		direction.z -= 1
		sprite.flip_h = true
	if Input.is_action_pressed("right"):
		direction.x -= 1
		sprite.flip_h = true
	elif Input.is_action_pressed("left"):
		direction.x +=1
		sprite.flip_h = false
	
	
	if direction.x == -1:
		if direction.z == -1:
			dust_instance.rotate_y(45)
		elif direction.z == 1:
			dust_instance.rotate_y(90)
		else:
			dust_instance.rotate_y(-67.5)
	elif direction.x == 1:
		if direction.z == -1:
			dust_instance.rotate_y(-45)
		elif direction.z == 1:
			dust_instance.rotate_y(-90)
		else:
			dust_instance.rotate_y(67.5)
	elif direction.z == 1:
		dust_instance.rotate_y(91.1)
	
	dust_instance.translation = translation 
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(translation + direction, Vector3.UP)
		sprite.animation = "walking"
	if direction == Vector3.ZERO:
		sprite.animation = "idle"
	
	
	
	if !isMonster:
		
		if Input.is_action_just_pressed("boost") && direction != Vector3.ZERO && canMove && timer > 0 && dashCount < maxDash:
			velocity.x = direction.x*speed*boost
			velocity.z = direction.z*speed*boost
			velocity.y = 0
			get_parent().add_child(dust_instance)
			if dashCount == 0:
				ticking = true
			dashCount += 1
			
		else:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
	else:
		if Input.is_action_just_pressed("boost") && direction != Vector3.ZERO && canMove && timer > 0 && dashCount < maxDash:
			velocity.x = direction.x*mSpeed*boost
			velocity.z = direction.z*mSpeed*boost
			velocity.y = 0;
			get_parent().add_child(dust_instance)
			if dashCount == 0:
				ticking = true
			dashCount += 1
		else:
			velocity.x = direction.x * mSpeed
			velocity.z = direction.z * mSpeed
			
	if canMove:
		if velocity.y > 3:
			velocity.y = 3
		
		velocity = move_and_slide(velocity, Vector3.UP)
	else:
		velocity.x = 0
		velocity.z = 0
		velocity = move_and_slide(velocity, Vector3.UP)
	
	if Input.is_action_just_pressed("monster"):
		isMonster = !isMonster
		
	if ticking:
		timer -= delta
		
	if timer <= 0:
		dashCount = 0
		ticking = false
		timer = timerMax
	
	#Vertical velocity
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

	 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
