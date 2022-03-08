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
var rng
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
	randomize()
	rng = RandomNumberGenerator.new()
	rng.randomize()

	matrix_gen() #create the 2d matrix with 'width' and 'height'
	randfill_matrix() #fill the matrix with numbers from 0 to 100
	binary_matrixer() # turn matrix into binary form if the value is high enough
	open_matrix() #determine the starting room of the matrix
	crop_matrix() #crop everything off that the player cannot access 

 #now that the matrix is complete, time to build the rooms based on the matrix
	place_rooms() #create dynamic_room children in the correct spots
	spawn_player() #make a player instance 
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
	rng.randomize()
	for x in range(width):
		for y in range(height):
			maptrix[x][y] = randi() % 101
	maptrix[0][0] = 100
	maptrix[0][1] = 100

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

#mark the starting room
func open_matrix():
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
	##var enemy = preload("res://prefabs/enemyBaseModel.tscn")


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

func get_matrix_room_rand_pos(var x, var y):
	return Vector3((x*room_x) + (randi() %room_x/2 - room_x/4),1,(y*room_y) + (randi() %room_y/2 - room_y/4))

func get_random_enemy():
	return enemys[randi() % enemy_count]

func get_random_decor():
	return decors[randi() % decor_count]

# spawn baddies in rooms
func spawn_baddies():
	var cur_enemy
	var enemy = preload("res://prefabs/error.tscn")
	var cur_decor
	var decor = preload("res://prefabs/error.tscn")

	for x in range(width):
		for y in range(height):

			# Only run if rooms value is higher than 1
			if (maptrix[x][y] >= 1):
				# Dont run if the current room is the spawn area or the exit area
				if (!(x == start_x && y == start_y) && !(x == last_x && y == last_y)):

			
						enemy = get_random_enemy()
						cur_enemy = enemy.instance()
						add_child(cur_enemy)

						cur_enemy.translation = Vector3((x*room_x) + (randi() %room_x/2 - room_x/4),1,(y*room_y) + (randi() %room_y/2 - room_y/4))

						if(randi() % 3 == 0):
							decor = get_random_decor()
							cur_decor = decor.instance()
							add_child(cur_decor)

							cur_decor.translation = Vector3((x*room_x) + (randi() %room_x/2 - room_x/4),1,(y*room_y) + (randi() %room_y/2 - room_y/4))

							

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
