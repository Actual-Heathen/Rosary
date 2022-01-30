extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var wall_left_mat = $Navigation/nmi/wall1/MeshInstance
onready var wall_right_mat = $Navigation/nmi/wall2/MeshInstance
onready var wall_top_mat = $Navigation/nmi/wall3/MeshInstance
onready var wall_bottom_mat = $Navigation/nmi/wall4/MeshInstance
onready var ground_mat = $Navigation/nmi/ground/MeshInstance

onready var wall_left_col = $Navigation/nmi/wall1/CollisionShape
onready var wall_right_col = $Navigation/nmi/wall2/CollisionShape
onready var wall_top_col = $Navigation/nmi/wall3/CollisionShape
onready var wall_bottom_col = $Navigation/nmi/wall4/CollisionShape
onready var ground_col = $Navigation/nmi/ground/CollisionShape

onready var wall_left = $Navigation/nmi/wall1
onready var wall_right = $Navigation/nmi/wall2
onready var wall_top = $Navigation/nmi/wall3
onready var wall_bottom = $Navigation/nmi/wall4
onready var ground = $Navigation/nmi/ground

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
