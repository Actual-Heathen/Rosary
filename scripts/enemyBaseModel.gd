extends KinematicBody

export var botSpeed = 15
export var botOffset = Vector3(5,0,5)
export var startingPosition = Vector3.ZERO
export var chaseRadius = 10
var velocity = Vector3(botSpeed,0,5)
onready var player = get_node("../../player")

func _physics_process(delta):
	if (translation.distance_to(player.global_transform.origin)>chaseRadius && translation.distance_to(startingPosition)<chaseRadius):
		var patrolDir = (getRoamingPosition() - global_transform.origin).normalized() 
		patrolDir.y = 0
		move_and_slide(patrolDir * botSpeed)
	
	elif (translation.distance_to(player.global_transform.origin)<chaseRadius):
		var direction = (player.global_transform.origin - global_transform.origin).normalized()
		move_and_slide(direction * botSpeed)

	else:
		var backToSpawnDir = (startingPosition - global_transform.origin).normalized() 
		backToSpawnDir.y = 0
		move_and_slide(backToSpawnDir* botSpeed)

	if (translation.distance_to(player.global_transform.origin)<2.236963):
		die()

func getRandomDir():
	var randomDirection = Vector3(rand_range(-1, 1),0,rand_range(-1, 1))
	return randomDirection

func getRoamingPosition():
	var roamDir = startingPosition + getRandomDir()*rand_range(20,30)
	return roamDir

func _ready():
	startingPosition = global_transform.origin
	pass # Replace with function body.

func die():
	queue_free()
