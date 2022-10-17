extends Area2D
# contains all the mthods and properties each piece might carry
# AllPieces will contain specfic nuances about difference bettwen pieces 
# (names, where they are on the spritesheet)

var rect = Rect2(0,0,0,0)


func loadTexture(spriteSheetRect: Rect2):
	var tex = load("res://art/debugPiecesSpriteSheet1.png")
	get_child(1).set_region(1)
	get_child(1).region_rect = spriteSheetRect
	get_child(1).texture = tex
	get_child(1).position = self.position
	get_child(1).centered = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
