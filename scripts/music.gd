extends Spatial

export var mMode = false
onready var monster = $monsterMusic
onready var girl = $girlMusic

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	girl.playing = true
	pass # Replace with function body.

func _process(delta):
	var player = get_parent()
	if mMode != player.isMonster:
		if player.isMonster:
			monster.playing = true
			girl.playing = false
			mMode = true
		else:
			monster.playing = false
			girl.playing = true
			mMode = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
