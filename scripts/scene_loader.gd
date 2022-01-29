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
	print(body)
	if body.name == "Player":
		timer.start(3)
		audio.playing = true


func _on_Timer_timeout():
	get_tree().change_scene(path_to_scene)
