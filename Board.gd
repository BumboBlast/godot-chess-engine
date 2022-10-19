extends Sprite
# sprite has a position and a scale
# size is art pixel size * scale
# pass the scale in resize functions, instead of size






"""
	Board Properties
"""
# stores updated piece dimensions to pass to other classes
onready var spriteRect = Rect2(
	self.get_position(),
	self.texture.get_size() * self.get_scale()
)

# piece object to instantiate dynamically
const NEWPIECE = preload("res://Piece.tscn")

# stores all the piece objects to iterate over
var allPieces = []





"""
	Board methods
"""

# call each time you change board size or position
func update_board_sprite_rect():
	self.spriteRect = Rect2(
		self.get_position(),
		self.texture.get_size() * self.get_scale()
	)





# calculate scale for new board size
# new pixels = old pixels * new scale
func set_board_size(percentWindowH):
	var nowSize = self.texture.get_size()
	var newSize = get_viewport().get_size()[1] * percentWindowH
	newSize = Vector2(newSize, newSize)
	var newScale = newSize / nowSize
	
	self.set_scale(newScale)
	update_board_sprite_rect()





# allign right board edge percent window away from right window edge 
# allign bottom board edge percent window away from bottom window edge
func set_board_position(percentWindowW, percentWindowH):
	self.centered = false
	
	var windowWidth = get_viewport().get_size()[0] #in pixels
	var windowHeight = get_viewport().get_size()[1] #in pixels
	var boardWidth = self.get_texture().get_size()[0] * self.get_scale()[0] #in pixels
	var boardHeight = self.get_texture().get_size()[1] * self.get_scale()[0] #in pixels
	
	# distance between window right/bottom edge and board right/bottom edge, in pixels
	# as calculation of percent of window width/height
	var percentWindowDiffW = windowWidth * percentWindowW
	var percentWindowDiffH = windowHeight * percentWindowH
	
	var newPos = Vector2(
		windowWidth - (boardWidth + (percentWindowDiffW)),
		windowHeight - (boardHeight + (percentWindowDiffH))	
	)
	self.set_position(newPos)
	update_board_sprite_rect()





# return pixel coordinate relative to board's origin
# origin + coordinate_offset
func calculate_square_coords(rankFile):
	# char -> int 'A' is 0. '1' is 0
	var rank = ord(rankFile[0]) - 65
	var file = ord(rankFile[1]) - 49

	var rankHeight = spriteRect.size[0] / 8
	var fileLength = spriteRect.size[0] / 8
	
	# looks like A1 is top left
	var squareXPos = spriteRect.position[0] + (fileLength * rank)
	var squareYPos = spriteRect.position[1] + (rankHeight * file)
	var squareWidth = fileLength
	var squareHeight = rankHeight
	
	return Rect2(squareXPos, squareYPos, squareWidth, squareHeight)





func instance_piece(name: String, parity: String):
	var newPiece = NEWPIECE.instance()
	newPiece.set_name(name)
	if (parity == "Dark"):
		newPiece.parity = true
	else:
		newPiece.parity = false
	
	newPiece.loadTexture()
	$AllPieces.add_child(newPiece)
	allPieces.append(newPiece)





# sets the piece's (and it's sprite's) position to the square rect's 
func place_piece(piece, square: String):
	var target_square = calculate_square_coords(square)
	piece.get_node("PieceSprite").set_position(target_square.position)
	#piece.update_piece_sprite_rect()





# adds a piece to the board (and to the piece array)
func add_piece(name: String, parity: String, square: String):
	instance_piece(name, parity)
	place_piece(allPieces.back(), square)





func _ready():
	
	set_board_size(0.80)
	set_board_position(0.10, 0.10)
	
	add_piece("Bishop", "Dark", "C3")



