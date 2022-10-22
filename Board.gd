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
	var file = ord(rankFile[0]) - 65
	var rank = 7 - (ord(rankFile[1]) - 49)

	var rankHeight = spriteRect.size[0] / 8
	var fileLength = spriteRect.size[0] / 8
	
	# looks like A1 is top left
	var squareXPos = spriteRect.position[0] + (fileLength * file)
	var squareYPos = spriteRect.position[1] + (rankHeight * rank)
	var squareWidth = fileLength
	var squareHeight = rankHeight
	
	return Rect2(squareXPos, squareYPos, squareWidth, squareHeight)





# make sure all the nodes are named uniquely
# if knight3 exists, will instance knight4
# this is probably prone to bugs but it works atm
func increment_name(pieceName: String):
	var increment = 1
	
	for p in $AllPieces.get_children():
		if (p.name.begins_with(pieceName)):
			increment = increment + 1
	
	return pieceName + String(increment)





# instantiate piece object, store into container
func instance_piece(name: String, parity: String):
	var newPiece = NEWPIECE.instance()
	newPiece.set_name(increment_name(name))
	$AllPieces.add_child(newPiece)
	
	
	if (parity == "Dark"):
		newPiece.parity = true
	else:
		newPiece.parity = false
	
	newPiece.loadTexture()
	allPieces.append(newPiece)





# sets the piece's (and it's sprite's) position to the square rect's 
func place_piece(piece, square: String):
	var target_square = calculate_square_coords(square)
	piece.set_position(target_square.position)
	print(piece.name, " places at square: ", square )
	piece.update_piece_sprite_rect()





# adds a piece to the board (and to the piece array)
func add_piece(name: String, parity: String, square: String):
	instance_piece(name, parity)
	place_piece(allPieces.back(), square)





# clear all the pieces from all containers
# free all piece nodes from memory
func wipeBoard():
	for p in $AllPieces.get_children():
		
		for _index in range(0, self.allPieces.size()):
			if (p == allPieces[_index]):
				allPieces.remove(_index)
				break
		
		p.queue_free()





# adds pieces to the board based on FEN string
# [x]Piece Placement - only add pieces in the middle portion
# []Active Color
# []Castling Rights
# []Possible En Passant Targets
# []Halfmove Clock
# []Fullmove Number
func loadFen(fen: String):
	wipeBoard()
	
	var rank = 1
	var file = 8
	
	for ch in fen:
		var space = String(char(rank + 64)) + String(char(file + 48))
		
		# if character is a letter
		if (ch == 'p'): add_piece("Pawn", "Dark", space)
		if (ch == 'P'): add_piece("Pawn", "Light", space)
		if (ch == 'n'): add_piece("Knight", "Dark", space)
		if (ch == 'N'): add_piece("Knight", "Light", space)
		if (ch == 'b'): add_piece("Bishop", "Dark", space)
		if (ch == 'B'): add_piece("Bishop", "Light", space)
		if (ch == 'r'): add_piece("Rook", "Dark", space)
		if (ch == 'R'): add_piece("Rook", "Light", space)
		if (ch == 'k'): add_piece("King", "Dark", space)
		if (ch == 'K'): add_piece("King", "Light", space)
		if (ch == 'q'): add_piece("Queen", "Dark", space)
		if (ch == 'Q'): add_piece("Queen", "Light", space)
		
		# how many spaces between next Piece
		if (ch.is_valid_integer()):
			rank = rank + int(ch)
			continue
		
		# increment file
		if (ch == '/'):
			file = file - 1
			rank = 0
		rank = rank + 1





func _ready():
	
	
	pass
	
	
	# giocco piano opening
	

	




