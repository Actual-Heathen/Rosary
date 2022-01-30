extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#onready var wall1 = $wall1/MeshInstance
#String var floor =	get_tree().get_current_scene().get_name()

const centerMaterials : Array = [
	preload("res://materials/stone.tres"),
	preload("res://materials/grass_stone.tres"),
	preload("res://materials/grass.tres")
	]

# Called when the node enters the scene tree for the first time.
func _ready():
#	if floor == "floor1":
		pass # Replace with function body.
#	wall1.set_surface_material(0, centerMaterials[1])

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
