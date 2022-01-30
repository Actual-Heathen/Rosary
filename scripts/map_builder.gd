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
	var cur_room
	for x in range(width):
		for y in range(height):
			if maptrix[x][y] >= 1:
				cur_room = room.instance()
				add_child(cur_room)
				cur_room.translation = Vector3(x*room_x,0,y*room_y)

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
				
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
