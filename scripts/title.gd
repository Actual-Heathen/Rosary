extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _on_start_pressed():
	get_tree().change_scene("res://scenes/garden.tscn");


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
