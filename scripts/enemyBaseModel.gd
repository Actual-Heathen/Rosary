extends KinematicBody

export var botSpeed = 15
export var botOffset = Vector3(5,0,5)
var velocity = Vector3(botSpeed,0,5)

const GRAVITY = 600

#var health = 5

onready var player = get_node("../../player")
onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * ProjectSettings.get_setting("physics/3d/default_gravity_vector")

var initialPos = translation
#func _physics_process(delta): 
#	print(self.get_position_in_parent())
#	if ((translation.x <= initialPos.x + botOffset.x) ||  (translation.z <= initialPos.z + botOffset.z)):
#		print('----------------------------------------------------------------------------------')
#		move_and_slide(velocity, Vector3(-5,0,5))

func _physics_process(delta):
	if player:
		var direction = (player.global_transform.origin - self.global_transform.origin).normalized()
		move_and_slide(direction * botSpeed)

		for i in get_slide_count():
			var collision = get_slide_collision(i)
			# if collision.collider.name == "Player":
			var object = collision.collider
			if object.is_in_group("player"):
#				object.die()
				pass


func _ready():
	pass # Replace with function body.

func _die():
	queue_free()
