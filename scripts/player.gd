extends KinematicBody
export var HP = 100 #player starting hp
##speed and movement variables##
export var wSpeed = 20     #girl walking speed
export var mSpeed = 15     #monster state walking speed
var speed = 0              #total speed value
export var boost = 4       #boost multiplier
export var fall_acceleration = 98
export var direction = Vector3.ZERO #player direction
var velocity = Vector3.ZERO  #player's actual velocity
##various player states##
export var canMove = true
export var isMonster = false
export var maxDash = 3
var dashCount = 0; #how many dashes have been done resets with the timer
var dashing = false #true while the player is dashing
var isSneaking = false 

var timerMax = 7 #timer reset value
var timer = timerMax #dash count timer
var ticking = false  #states if the timer is running
var dashTime = 0;  #time while i dash modifies the time in animation
##load objects##
onready var sprite = $CSGMesh
onready var dhb = $longHit/CSGMesh2
onready var lrhb = $dash/CollisionShape

var dust = preload("res://prefabs/dashparticle.tscn") #dust particle
var dust = preload("res://scenes/PauseMenu.tscn") #dust and mold


func _physics_process(delta):
	var dust_instance = dust.instance()
	var pause_instance = pause.instance()
	
	velocity.y -= fall_acceleration * delta
	direction = Vector3.ZERO
	
	if HP <= 0:
		sprite.animation = "death"
		canMove = false
	elif canMove:
		if Input.is_action_pressed(("forward")):
			direction.z += 1
			direction.x -= 1
			sprite.flip_h = false
		elif Input.is_action_pressed("back"):
			direction.z -= 1
			direction.x += 1
			sprite.flip_h = true
		if Input.is_action_pressed("right"):
			direction.x -= 1
			direction.z -= 1
			sprite.flip_h = true
		elif Input.is_action_pressed("left"):
			direction.x +=1
			direction.z += 1
			sprite.flip_h = false
		
		if Input.is_action_just_pressed("pause"):
			canMove = false
			add_child(pause_instance)
		
		if Input.is_action_just_pressed("attack"):
			sprite.animation = "long"
		
		##dust angle calculations##
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
		
		#normalize vectors#
		if direction != Vector3.ZERO:
			direction = direction.normalized()
		if direction == Vector3.ZERO:
				sprite.animation = "idle"
		elif sprite.animation != "dash" || sprite.frame > 6: #change sprite to walking if not dashing and moving
			sprite.animation = "walking"
		
		##speed calculations##
		if isMonster:
			speed = mSpeed
			if dashing:
				speed *= boost
		else:
			speed = wSpeed
			if dashing:
				speed *= boost
			
		if direction != Vector3.ZERO:
			if !isMonster: #for monster movement calculations#
				if Input.is_action_just_pressed("boost") && timer > 0 && dashCount < maxDash && !dashing:
					velocity.y = 0
					sprite.animation = "dash"
					get_parent().add_child(dust_instance)
					if dashCount == 0: #start dash timer
						ticking = true
					dashCount += 1#increase dash counter
					dashing = true #set dashing flag to true
				elif dashing: #special dashing calculations
					velocity.y = 0
			else: #for normal movement calculations#
				if Input.is_action_just_pressed("boost") && timer > 0 && dashCount < maxDash && !dashing:
					velocity.y = 0;
					sprite.animation = "dash"
					get_parent().add_child(dust_instance)
					if dashCount == 0: #start dash timer
						ticking = true
					dashCount += 1 #inc dash timer
					dashing =true #set dash flag on
				elif dashing: #dash calculations
					velocity.y = 0
				 #normal calculations
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed  #*2 to compensate for the perspective
				
		if velocity.y > 3: #velocity cap
			velocity.y = 3
		velocity = move_and_slide(velocity, Vector3.UP)
		
		
		if Input.is_action_just_pressed("monster"): #change to monster mode#
			isMonster = !isMonster
			
		
		#timer logic#
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
		
		#hitbox enabling##
		if sprite.animation == "dash":
			dhb.disabled = false
			lrhb.disabled = true
	else:
			velocity.x = 0
			velocity.z = 0
			velocity = move_and_slide(velocity, Vector3.UP)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_body_body_entered(dash,longHit):  ##for enemy damaging##  ####WIP####
	print(dash.name)
	if dash.name == "enemy":
		dash.enemyHP -= 30
	if longHit.name == "enemy":
		longHit.enemyHP -= 20

	 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
