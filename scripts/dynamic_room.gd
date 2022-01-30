extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var wall_left_mat = $wall1/MeshInstance
onready var wall_right_mat = $wall2/MeshInstance
onready var wall_top_mat = $wall3/MeshInstance
onready var wall_bottom_mat = $wall4/MeshInstance
onready var ground_mat = $ground/MeshInstance

onready var wall_left_col = $wall1/CollisionShape
onready var wall_right_col = $wall2/CollisionShape
onready var wall_top_col = $wall3/CollisionShape
onready var wall_bottom_col = $wall4/CollisionShape
onready var ground_col = $ground/CollisionShape

onready var wall_left = $wall1
onready var wall_right = $wall2
onready var wall_top = $wall3
onready var wall_bottom = $wall4
onready var ground = $ground

export (bool) var left_wall
export (bool) var right_wall
export (bool) var top_wall
export (bool) var bottom_wall

const centerMaterials : Array = [
	preload("res://materials/stone.tres"),
	preload("res://materials/grass_stone.tres"),
	preload("res://materials/grass.tres")
	]

# Called when the node enters the scene tree for the first time.
func _ready():
	var floor_name = get_tree().get_current_scene().get_name()
	var floor_num = -1
	if floor_name == "floor1":
		floor_num = 0 
	if floor_name == "floor2":
		floor_num = 1 
	if floor_name == "floor3":
		floor_num = 2

	wall_left_mat.set_surface_material(0, centerMaterials[floor_num])
	wall_right_mat.set_surface_material(0, centerMaterials[floor_num])
	wall_top_mat.set_surface_material(0, centerMaterials[floor_num])
	wall_bottom_mat.set_surface_material(0, centerMaterials[floor_num])
	ground_mat.set_surface_material(0, centerMaterials[floor_num])

	wall_left_mat.visible = left_wall
	wall_right_mat.visible = right_wall
	wall_top_mat.visible = top_wall
	wall_bottom_mat.visible = bottom_wall

	wall_left_col.disabled = !left_wall
	wall_right_col.disabled = !right_wall
	wall_top_col.disabled = !top_wall
	wall_bottom_col.disabled = !bottom_wall

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
