extends Node
# contains game rules


#indicates which side moves next
var active_color: bool


func get_active_color():
	if (active_color == true):
		return "dark"
	else:
		return "light"




func set_active_color(color: String):
	if (color == "light"):
		active_color = false
	elif (color == "dark"):
		active_color = true
	else:
		active_color = false
		print(" error setting active color. Light chosen")



# default is no, load FEN makes it yes
var castling_rights_white_kingside = false
var castling_rights_black_kingside = false
var castling_rights_white_queenside = false
var castling_rights_black_queenside = false

# enpassant target
# can be a space or '-'
var enpassant_target: String

# how many moves both players have made since the last pawn advance or piece capture
# When this counter reaches 100 (allowing each player to make 50 moves), the game ends in a draw.
# string, so that its easier to append characters in loadFEN
var halfmove_clock: String

# the number of completed turns in the game.
# incemented each tiem black moves
# string, for appending characters in loadFEN 
var fullmove_clock: String

# map of square names to pieces occupying them
var spaces = {}

# create dictionary of spaces
# used in this class, and updated frequently, 
# rather than calling node tree hundreds of times
func make_spaces_dictionary_keys():
	for file in 8:
		for rank in 8:
			spaces[String(char(file + 65)) + String(char(rank + 49))] = false






# can be called everytime board state changes
func update_spaces_dictionary():
	
	# wipe dictionary
	spaces.clear()
	
	# rebuild dictionary with updated Space-piece pairings
	make_spaces_dictionary_keys()
	for piece in $Board/AllPieces.get_children():
		
		if (piece.current_space):
			spaces[piece.current_space] = piece






# generate and return a FEN for the current board state
func get_fen():
	pass






# returns set of legal spaces the Pawn in question can move
func pawn_mobility(piece, current_space):
	var pawn_mobility_set = []
	# decrement rank
	pawn_mobility_set.push_back(current_space[0] + (char(ord(current_space[1]) - 1)))
	return pawn_mobility_set



func knight_mobility(piece, current_space):
	var knight_mobility_set = []
	# decrement file 1, increment rank 2 (top left)
	knight_mobility_set.push_back((char(ord(current_space[0]) - 1)) + (char(ord(current_space[1]) + 2)))
	# increment file 1, increment rank 2 (top right)
	knight_mobility_set.push_back((char(ord(current_space[0]) + 1)) + (char(ord(current_space[1]) + 2)))
	# increment file 2, increment rank 1 (right top)
	knight_mobility_set.push_back((char(ord(current_space[0]) + 2)) + (char(ord(current_space[1]) + 1)))
	# increment file 2, decrement rank 1 (right bottom)
	knight_mobility_set.push_back((char(ord(current_space[0]) + 2)) + (char(ord(current_space[1]) - 1)))
	# increment file 1, decrement rank 2 (bottom right)
	knight_mobility_set.push_back((char(ord(current_space[0]) + 1)) + (char(ord(current_space[1]) - 2)))
	# decrement file 1, decrement rank 2 (bottom left)
	knight_mobility_set.push_back((char(ord(current_space[0]) - 1)) + (char(ord(current_space[1]) - 2)))
	# decrement file 2, decrement rank 1 (left bottom)
	knight_mobility_set.push_back((char(ord(current_space[0]) - 2)) + (char(ord(current_space[1]) - 1)))
	# decrement file 2, increment rank 1 (left top)
	knight_mobility_set.push_back((char(ord(current_space[0]) - 2)) + (char(ord(current_space[1]) + 1)))
	return knight_mobility_set



func bishop_mobility(piece, current_space):
	var bishop_mobility_set = []
	# calculate L and R diagonals , then pushback all spaces on that diagonal
	var l_diagonal = current_space
	for n in 8:
		if (ord(l_diagonal[0]) <= ord('A')): break
		if (ord(l_diagonal[1]) <= ord('1')): break
		l_diagonal = ((char(ord(l_diagonal[0]) - 1)) + (char(ord(l_diagonal[1]) - 1)))
	
	var r_diagonal = current_space
	for n in 8:
		if (ord(r_diagonal[0]) <= ord('A')): break
		if (ord(r_diagonal[1]) >= ord('8')): break
		r_diagonal = ((char(ord(r_diagonal[0]) - 1)) + (char(ord(r_diagonal[1]) + 1)))
	
	# push back all the spaces on these diagonal
	for n in 8:
		var next_space_up_right = ((char(ord(l_diagonal[0]) + n)) + (char(ord(l_diagonal[1]) + n)))
		var next_space_down_left = ((char(ord(r_diagonal[0]) + n)) + (char(ord(r_diagonal[1]) - n)))
		bishop_mobility_set.push_back(next_space_up_right)
		bishop_mobility_set.push_back(next_space_down_left)
	return bishop_mobility_set


func rook_mobility(piece, current_space):
	var rook_mobility_set = []
	# calculate file/rank , then pushback all spaces on that file/rank
	var file = current_space
	for n in 8:
		if (ord(file[1]) <= ord('1')): break
		file = (file[0] + (char(ord(file[1]) - 1)))
	
	var rank = current_space
	for n in 8:
		if (ord(rank[0]) <= ord('A')): break
		rank = ((char(ord(rank[0]) - 1)) + rank[1])
	
	# push back all the spaces on these file/rank
	for n in 8:
		var next_space_up = (file[0] + (char(ord(file[1]) + n)))
		var next_space_left = ((char(ord(rank[0]) + n)) + rank[1])
		rook_mobility_set.push_back(next_space_up)
		rook_mobility_set.push_back(next_space_left)
	return rook_mobility_set




# returns the set of moves that a piece could make if the board were empty
func consult_piece_mobility(piece, current_space):
	var piece_mobility_set = []
	
	# if piece is black
	if (piece.parity): 
		
		if (piece.name.begins_with("Pawn")):
			piece_mobility_set = pawn_mobility(piece, current_space)
		
		if (piece.name.begins_with("Knight")): 
			piece_mobility_set = knight_mobility(piece, current_space)
		
		if (piece.name.begins_with("Bishop")):
			piece_mobility_set = bishop_mobility(piece, current_space)
			
		
		if (piece.name.begins_with("Rook")):
			piece_mobility_set = rook_mobility(piece, current_space)
			
	
	
	
	
	# trim the off-board moves
	for index in range(piece_mobility_set.size() - 1, -1, -1):
		var move = piece_mobility_set[index]
		if (ord(move[0]) < ord('A')) or (ord(move[0]) > ord('H')) or \
		(ord(move[1]) < ord('1')) or (ord(move[1]) > ord('8')) or \
		(move == current_space):
			piece_mobility_set.erase(move)
	
	
	print ("LEGAL MOVES FOR ", piece.name, ": ", piece_mobility_set)
	return piece_mobility_set
	pass






# uses the piece and board state to calculate list of legal spaces
# does not consider coordinates. Only file/ rank
# should be able to return a list
func get_legal_spaces(piece):
	
	var p_current_space = piece.current_space
	
	# step one, consider the legal spots a piece could land
	# step two, consider which spots are unoccupied
	#	make sure bishops, rooks, queen are stopped by first occupied square
	# set of legal moves are the interesection of steps 1,2,3
	
	# list of spaces a piece could move if the board were empty
	var piece_mobility = consult_piece_mobility(piece, p_current_space)
	return piece_mobility





# Called when the node enters the scene tree for the first time.
func _ready():
	
	update_spaces_dictionary()
	
	pass
