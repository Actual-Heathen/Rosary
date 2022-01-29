extends Node


export(int) var width  
export(int) var height
export(int) var density
var maptrix = []

func _ready():
	matrix_gen() #create the 2d matrix with 'width' and 'height'
	randfill_matrix() #fill the matrix with numbers from 0 to 100
	print_matrix() #print out the elements of the matrix for debugging
	binary_matrixer() # turn matrix into binary form if the value is high enough
	print_matrix() #print out the elements of the matrix for debugging
	snip_matrix() # snip nonconnecting rooms off
	print("S N I P")
	print_matrix() #print out the elements of the matrix for debugging
 #now that the matrix is complete, time to build the rooms based on the matrix
	place_rooms() #create dynamic_room children in the correct spots


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

#create dynamic_room children in the correct spots
func place_rooms():
	var room = preload("res://prefabs/dynamic_room.tscn")
	var cur_room
	for x in range(width):
		for y in range(height):
			if maptrix[x][y] == 1:
				cur_room = room.instance()
				add_child(cur_room)
				cur_room.translation = Vector3(x*2,y*2,0)

				
				
	


				
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
