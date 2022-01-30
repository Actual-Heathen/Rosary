extends KinematicBody

export var botSpeed = 15
export var botOffset = Vector3(5,0,5)
export var startingPosition = Vector3.ZERO

var velocity = Vector3(botSpeed,0,5)
onready var player = get_node("../../player")

func _physics_process(delta):
	if (translation.distance_to(player.global_transform.origin)>5 && translation.distance_to(startingPosition)<5):
		var patrolDir = (getRoamingPosition() - global_transform.origin).normalized() 
		patrolDir.y = 0
		move_and_slide(patrolDir * botSpeed)
	
	elif (translation.distance_to(player.global_transform.origin)<5):
		var direction = (player.global_transform.origin - global_transform.origin).normalized()
		move_and_slide(direction * botSpeed)
		
	else:
		var backToSpawnDir = (startingPosition - global_transform.origin).normalized() 
		backToSpawnDir.y = 0
		move_and_slide(backToSpawnDir* botSpeed)

func getRandomDir():
	var randomDirection = Vector3(rand_range(-1, 1),0,rand_range(-1, 1))
	return randomDirection

func getRoamingPosition():
	var roamDir = startingPosition + getRandomDir()*rand_range(20,30)
	return roamDir
	
func _ready():
	startingPosition = global_transform.origin
	pass # Replace with function body.

func _die():
	queue_free()
