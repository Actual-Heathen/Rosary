extends Node

export(String) var exit_scene
export(int) var width  
export(int) var height
export(int) var density
var maptrix = []
var start_x
var start_y
var last_x
var last_y
export(int) var room_x
export(int) var room_y

const decor_count = 3
const decors : Array = [
	preload("res://prefabs/SM_Tree.tscn"),
	preload("res://prefabs/SM_TreeStump.tscn"),
	preload("res://prefabs/SM_Stained_Glass.tscn")
	]
const enemy_count=3
const enemys : Array = [
	preload("res://prefabs/Enemy_bishop.tscn"),
	preload("res://prefabs/Enemy_demon.tscn"),
	preload("res://prefabs/Enemy.tscn")
	]

func _ready():
	matrix_gen() #create the 2d matrix with 'width' and 'height'
	randfill_matrix() #fill the matrix with numbers from 0 to 100
	print_matrix() #print out the elements of the matrix for debugging
	binary_matrixer() # turn matrix into binary form if the value is high enough
	print_matrix() #print out the elements of the matrix for debugging
	snip_matrix() # snip nonconnecting rooms off
	print("S N I P")
	print_matrix() #print out the elements of the matrix for debugging
	open_matrix() #determine the starting room of the matrix
	crop_matrix() #crop everything off that the player cannot access 
	print("C R O P P E D")
	print_matrix() #print out the elements of the matrix for debugging

 #now that the matrix is complete, time to build the rooms based on the matrix
	place_rooms() #create dynamic_room children in the correct spots
	spawn_player()
	spawn_exit()
	spawn_baddies()


#create the 2d matrix with 'width' and 'height'
func matrix_gen():
	for _x in range(width):
		var col = []
		col.resize(height)
		maptrix.append(col)

#fill the matrix with numbers from 0 to 100
func randfill_matrix():
	randomize()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for x in range(width):
		for y in range(height):
			maptrix[x][y] = randi() % 101
	maptrix[0][0] = 1
	maptrix[0][1] = 1

#print out the elements of the matrix for debugging
func print_matrix():
	for x in range(width):
		for y in range(height):
			print(maptrix[x][y])
		print("Next Row")


# turn matrix into binary form if the value is high enough
func binary_matrixer():
	for x in range(width):
		for y in range(height):
			if maptrix[x][y] >= density:
				maptrix[x][y] = 1
			else:
				maptrix[x][y] = 0
				
# snip nonconnecting rooms off 
func snip_matrix():
	var safe = false
	for x in range(width):
		for y in range(height):
			if maptrix[x][y] == 1:
				safe = false
				if x+1 < width  && maptrix[x+1][y] == 1:
					safe = true
				if x-1 > 0      && maptrix[x-1][y] == 1:
					safe = true
				if y+1 < height && maptrix[x][y+1] == 1:
					safe = true
				if y-1 > 0      && maptrix[x][y-1] == 1:
					safe = true
				if safe == false:
					maptrix[x][y] = 0

#mark the starting room
func open_matrix():
	randomize()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var x = randi() % width 
	var y = randi() % height
	while maptrix[x][y] != 1:
		x = randi() % width 
		y = randi() % height
	maptrix[x][y] = 2
	start_x = x
	start_y = y

#remove inacessable rooms
func crop_matrix():
	var safe = true
	var run = true
	var updated_last = true
	while run == true:
		run = false
		for x in range(width):
			for y in range(height):
				safe = false
				updated_last = false 
				if maptrix[x][y] == 1:
					run = true
					if x+1 < width  && maptrix[x+1][y] == 2:
						safe = true
					if x-1 > 0      && maptrix[x-1][y] == 2:
						safe = true
					if y+1 < height && maptrix[x][y+1] == 2:
						safe = true
					if y-1 > 0      && maptrix[x][y-1] == 2:
						safe = true
					if safe == true:
						maptrix[x][y] = 2
						updated_last = true
						last_x = x
						last_y = y
					elif safe == false && updated_last == false:
						maptrix[x][y] = 0
					
		


#create dynamic_room children in the correct spots
func place_rooms():
	var room = preload("res://prefabs/dynamic_room.tscn")
	var enemy = preload("res://prefabs/enemyBaseModel.tscn")

	var cur_room
	for x in range(width):
		for y in range(height):
			if maptrix[x][y] >= 1:
				cur_room = room.instance()
				add_child(cur_room)
				cur_room.translation = Vector3(x*room_x,0,y*room_y)
				if x+1 < width  && maptrix[x+1][y] == 2:
					cur_room.right_wall = true
				if x-1 > 0      && maptrix[x-1][y] == 2:
					cur_room.left_wall = true
				if y+1 < height && maptrix[x][y+1] == 2:
					cur_room.top_wall = true
				if y-1 > 0      && maptrix[x][y-1] == 2:
					cur_room.bottom_wall = true


# spawn the player at the starting room
func spawn_player():
	var player_prefab = preload("res://prefabs/player.tscn")
	var player = player_prefab.instance()
	add_child(player)
	player.translation = Vector3(start_x*room_x,1,start_y*room_y)
	#player.translation = Vector3(0,0,0)

# spawn the scene_loader at the ending room	
func spawn_exit():
	var exit_prefab = preload("res://prefabs/scene_loader.tscn")
	var exit = exit_prefab.instance()
	add_child(exit)
	exit.path_to_scene  = (exit_scene)
	exit.translation = Vector3(last_x*room_x,1,last_y*room_y)

# spawn baddies in rooms
func spawn_baddies():
	randomize()
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	var enemy = preload("res://prefabs/Enemy.tscn")
	#var enemy = preload("res://prefabs/enemyBaseModel.tscn")
	var decor = preload("res://prefabs/SM_Tree.tscn")
	var cur_enemy
	var cur_decor
	for x in range(width):
		for y in range(height):
			if maptrix[x][y] >= 1:
				if (!(x == start_x && y == start_y)):
					if (!(x == last_x && y == last_y)):
						enemy = enemys[randi() % enemy_count]
						cur_enemy = enemy.instance()
						add_child(cur_enemy)
						cur_enemy.translation = Vector3((x*room_x)-(room_x/2) + randi() %room_y,1,(x*room_y)-(room_y/2) + randi() %room_y)
						if(randi() % 3 == 0):
							decor = decors[randi() % decor_count]
							cur_decor = decor.instance()
							add_child(cur_decor)
							cur_decor.translation = Vector3((x*room_x)-(room_x/2) + randi() %room_y,1,(x*room_y)-(room_y/2) + randi() %room_y)
							

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
