extends KinematicBody

export var botSpeed = 15

export var fall_acceleration = 98
export var chaseRadius = 10
export var enemyHP = 100
export var attackRadius = 3
export var enemyAttackFreq = 1
export var enemyDmg = 20
export (String) var player_path = '../player'

onready var player = get_node(player_path)
onready var sprite = $AnimatedSprite3D
onready var timer = get_node("Timer")
var enemyCanAttack = 'Y'
var startingPosition


func _physics_process(delta):

	if (translation.distance_to(player.global_transform.origin)>chaseRadius && translation.distance_to(startingPosition)<chaseRadius):
		var patrolDir = (getRoamingPosition() - global_transform.origin).normalized() 
		patrolDir.y = -fall_acceleration * delta
		move_and_slide(patrolDir * botSpeed)

	elif (translation.distance_to(player.global_transform.origin)<chaseRadius && translation.distance_to(player.global_transform.origin)>attackRadius):
		var direction = (player.global_transform.origin - global_transform.origin).normalized()
		direction.y = -fall_acceleration * delta
		move_and_slide(direction * botSpeed)

	elif(translation.distance_to(player.global_transform.origin)<attackRadius):
		var direction = (player.global_transform.origin - global_transform.origin).normalized()
		attack()
		direction.y = -fall_acceleration * delta
		move_and_slide(direction * botSpeed)

	else:
		startingPosition = global_transform.origin

	if (enemyHP <= 0):
		sprite.animation = 'Dead'
		die()

func attack():
	sprite.animation = 'Attack'
	if enemyCanAttack == 'Y':
		player.HP -= 20
		enemyCanAttack = 'N'
		sprite.animation = 'Patrol'
		timer.start()

func getRandomDir():
	var randomDirection = Vector3(rand_range(-1, 1),0,rand_range(-1, 1))
	return randomDirection

func getRoamingPosition():
	var roamDir = startingPosition + getRandomDir()*rand_range(20,30)
	return roamDir

func _ready():
	timer.set_wait_time(enemyAttackFreq)
	startingPosition = global_transform.origin

func die():
	queue_free()

func timer_timeout():
	enemyCanAttack = 'Y'
	timer.set_wait_time(1)
