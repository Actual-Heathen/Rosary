extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$"VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/HBoxContainer/Resume".grab_focus()
	



#func _input(event):
	
	#if event.is_action_pressed("ui_cancel"):
		#$VBoxContainer/CenterContainer/Pause
func _on_Resume_pressed():
	get_parent().canMove = true
	queue_free()

func _on_Restart_pressed():
	get_tree().change_scene("res://scenes/Menu.tscn")

func _on_Options_pressed():
	pass # Replace with function body.

func _on_Menu_pressed():
	get_tree().change_scene("res://scenes/Menu.tscn")








