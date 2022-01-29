extends KinematicBody

export var botSpeed = 5
export var botOffset = Vector3(5,0,5)
var velocity = Vector3(botSpeed,0,5)
const ACCEL = 5.0
const DEACCEL = 20.0
const MAX_SPEED = 2.0
const ROT_SPEED = 1.0


var prev_advance = false
var dying = false
var rot_dir = 4

onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * ProjectSettings.get_setting("physics/3d/default_gravity_vector")


func _physics_process(delta): 


	print(translation)

	if (translation.x <= 5):
		print('----------------------------------------------------------------------------------')
		move_and_slide(velocity, botOffset)
	elif (translation.x > 5) :
		print('************************************************************************************')
		move_and_slide(-velocity, -botOffset)

	#print(get_floor_normal())
	#print('------')
	
func _die():
	queue_free()
