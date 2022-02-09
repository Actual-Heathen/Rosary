extends Spatial

export(String) var path_to_scene
onready var timer = $Timer
onready var audio = $AudioStreamPlayer
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_body_body_entered(body):
	print(body.name)
	if body.name == "player":
		body.fall_acceleration = -50
		body.canMove = false
		timer.start(2)
		audio.playing = true


func _on_Timer_timeout():
	if (get_tree().change_scene(path_to_scene)):
		return(get_tree().change_scene("res://scenes/error_scene.tscn"))
