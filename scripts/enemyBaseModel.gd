extends KinematicBody

export var botSpeed = 15
export var botOffset = Vector3(5,0,5)
var velocity = Vector3(botSpeed,0,5)


onready var player = get_node("../../player")

func _physics_process(delta):
	if (translation.distance_to(player.global_transform.origin)<5):
		var direction = (player.global_transform.origin - global_transform.origin).normalized()
		move_and_slide(direction * botSpeed)

		for i in get_slide_count():
			var collision = get_slide_collision(i)
			# if collision.collider.name == "Player":
			var object = collision.collider
			if object.is_in_group("player"):
				object.die()
			


func _ready():
	pass # Replace with function body.

func _die():
	queue_free()
