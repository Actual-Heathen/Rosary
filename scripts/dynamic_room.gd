extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var wall1_mat = $wall1/MeshInstance
onready var wall2_mat = $wall2/MeshInstance
onready var wall3_mat = $wall3/MeshInstance
onready var wall4_mat = $wall4/MeshInstance
onready var ground_mat = $ground/MeshInstance

onready var wall1_col = $wall1/CollisionShape
onready var wall2_col = $wall2/CollisionShape
onready var wall3_col = $wall3/CollisionShape
onready var wall4_col = $wall4/CollisionShape
onready var ground_col = $ground/CollisionShape

onready var wall1 = $wall1
onready var wall2 = $wall2
onready var wall3 = $wall3
onready var wall4 = $wall4
onready var ground = $ground

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

	wall1_mat.set_surface_material(0, centerMaterials[floor_num])
	wall2_mat.set_surface_material(0, centerMaterials[floor_num])
	wall3_mat.set_surface_material(0, centerMaterials[floor_num])
	wall4_mat.set_surface_material(0, centerMaterials[floor_num])
	ground_mat.set_surface_material(0, centerMaterials[floor_num])

	wall1_mat.visible = false
	wall2_mat.visible = false
	wall3_mat.visible = false
	wall4_mat.visible = false

	wall1_col.disabled = true
	wall2_col.disabled = true
	wall3_col.disabled = true
	wall4_col.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
