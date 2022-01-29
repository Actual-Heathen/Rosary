extends Node


export(int) var width  
export(int) var height
export(int) var density
var maptrix = []

func _ready():
	matrix_gen() #create the 2d matrix with 'width' and 'height'
	randfill_matrix() #fill the matrix with numbers from 0 to 100
	print_matrix() #print out the elements of the matrix for debugging



#create the 2d matrix with 'width' and 'height'
func matrix_gen():
	for _x in range(width):
		var col = []
		col.resize(height)
		maptrix.append(col)

#print out the elements of the matrix for debugging
func print_matrix():
	for x in range(width):
		for y in range(height):
			print(maptrix[x][y])
		print("Next Row")

#fill the matrix with numbers from 0 to 100
func randfill_matrix():
	randomize()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for x in range(width):
		for y in range(height):
			maptrix[x][y] = randi() % 101 



				
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
