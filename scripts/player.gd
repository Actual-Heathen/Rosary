extends KinematicBody

export var wSpeed = 20
export var mSpeed = 15
var speed = 0
export var isMonster = false
var velocity = Vector3.ZERO
export var boost = 4
export var fall_acceleration = 98
export var canMove = true
export var direction = Vector3.ZERO
export var maxDash = 3
var dashCount = 0;
var timerMax = 7
var timer = timerMax
var ticking = false
var dashTime = 0;
var dashing = false
onready var sprite = $CSGMesh
var isSneaking = false


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
	if sprite.animation != "dash" || sprite.frame > 6:
		if direction == Vector3.ZERO:
			sprite.animation = "idle"
		else:
			sprite.animation = "walking"
	
	if isMonster:
		speed = mSpeed
		if dashing:
			speed *= boost
	else:
		speed = wSpeed
		if dashing:
			speed *= boost
		
	
	
	if !isMonster:
		
		if Input.is_action_just_pressed("boost") && direction != Vector3.ZERO && canMove && timer > 0 && dashCount < maxDash && !dashing:
			velocity.x = direction.x*speed
			velocity.z = direction.z*speed
			velocity.y = 0
			sprite.animation = "dash"
			get_parent().add_child(dust_instance)
			if dashCount == 0:
				ticking = true
			dashCount += 1
			dashing = true
		elif dashing:
			velocity.x = direction.x*speed
			velocity.z = direction.z*speed
			velocity.y = 0
		else:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
	else:
		if Input.is_action_just_pressed("boost") && direction != Vector3.ZERO && canMove && timer > 0 && dashCount < maxDash && !dashing:
			velocity.x = direction.x*speed
			velocity.z = direction.z
			velocity.y = 0;
			sprite.animation = "dash"
			get_parent().add_child(dust_instance)
			if dashCount == 0:
				ticking = true
			dashCount += 1
			dashing =true
		elif dashing:
			velocity.x = direction.x*speed
			velocity.z = direction.z*speed
			velocity.y = 0
		else:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
			
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
	if dashing:
		dashTime += delta
	if dashTime > .3:
		dashing = false
		dashTime = 0
	
	#Vertical velocity
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

	 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
