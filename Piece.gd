extends Area2D
# contains all the mthods and properties each piece might carry
# AllPieces will contain specfic nuances about difference bettwen pieces 
# (names, where they are on the spritesheet)




"""
	Piece Properties
"""


# stores the boundry of the sprite
var spriteRect = Rect2(
	0, 0, 0, 0
)

# false = light, true = dark
# default true/dark
var parity = true



"""
	Piece methods
"""

func calculate_sprite_location(pieceName: String, spriteLength, spriteHeight):

	if (pieceName.begins_with("Pawn")):
		if (self.parity):
			return Vector2(spriteLength * 0, spriteHeight * 0)
		else:
			return Vector2(spriteLength * 0, spriteHeight * 1)
	if (pieceName.begins_with("King")):
		if (self.parity):
			return Vector2(spriteLength * 1, spriteHeight * 0)
		else:
			return Vector2(spriteLength * 1, spriteHeight * 1)
	if (pieceName.begins_with("Bishop")):
		if (self.parity):
			return Vector2(spriteLength * 2, spriteHeight * 0)
		else:
			return Vector2(spriteLength * 2, spriteHeight * 1)
	if (pieceName.begins_with("Knight")):
		if (self.parity):
			return Vector2(spriteLength * 3, spriteHeight * 0)
		else:
			return Vector2(spriteLength * 3, spriteHeight * 1)
	if (pieceName.begins_with("Rook")):
		if (self.parity):
			return Vector2(spriteLength * 4, spriteHeight * 0)
		else:
			return Vector2(spriteLength * 4, spriteHeight * 1)
	if (pieceName.begins_with("Queen")):
		if (self.parity):
			return Vector2(spriteLength * 5, spriteHeight * 0)
		else:
			return Vector2(spriteLength * 5, spriteHeight * 1)
	return Vector2(spriteLength * 0, spriteHeight * 0) # default value





func find_spriteSheet_rect(pieceName: String, texSize: Vector2):
	
	# 6 unique pieces, 2 colors (6 x 2 pieces)
	var spriteLength = texSize[0] / 6#pixels
	var spriteHeight = texSize[1] / 2#pixels
	
	# where on the spritesheet the tex is
	var spriteSheetRect = Rect2(
		calculate_sprite_location(pieceName, spriteLength, spriteHeight),
		Vector2(spriteLength, spriteHeight)
	)
	return spriteSheetRect





# update the variable storing the size of the texture
# this is used to pass to other objects incase they want it
# be sure to call this whenever you update art or like boardsizes or something
# also make sure the texture is same place as parent node! (idk why)
func update_piece_sprite_rect():
	self.spriteRect = Rect2(
		self.get_position(),
		$PieceSprite.get_region_rect().size * self.get_scale()
	)
	# node and sprite should share same coords (weird)
	
	# collision is the same shape as texture rect





func loadTexture():
	var tex = load("res://art/debugPiecesSpriteSheet1.png")
	
	# rect defining where on the spritesheet the piece is located
	var spriteSheetRect = find_spriteSheet_rect(self.name, tex.get_size())
	
	$PieceSprite.texture = tex
	$PieceSprite.set_region(true)
	$PieceSprite.set_region_rect(spriteSheetRect)
	$PieceSprite.visible = true
	
	#board scale
	var new_scale = get_parent().get_parent().get_scale()
	
	self.set_scale(new_scale)
	update_piece_sprite_rect()




"""
Event Handlers
"""







# Called when the node enters the scene tree for the first time.
func _ready():
	

	pass # Replace with function body.





func _on_Piece_mouse_entered():
	print("PIECE mouse entered")
	pass # Replace with function body.


func _on_Piece_mouse_exited():
	print("PIECE mouse exited")
	pass # Replace with function body.
