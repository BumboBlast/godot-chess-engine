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
# updated every single piece_placement
var occupied_spaces = {}







# create dictionary of spaces
# used in this class, and updated frequently, 
# rather than calling node tree hundreds of times
# can be called everytime board state changes
func update_spaces_dictionary():
	
	# wipe dictionary
	occupied_spaces.clear()
	
	# rebuild dictionary with updated Space-piece pairings
	#make_spaces_dictionary_keys()
	for piece in $Board/AllPieces.get_children():
		
		if (piece.current_space):
			occupied_spaces[piece.current_space] = piece






# generate and return a FEN for the current board state
func get_fen():
	pass

# returns the piece if occupied, else returns false if empty
func is_occupied(space):
	var occupied_array = []
	
	for sp in occupied_spaces:
		
		occupied_array.push_back(sp)
		if (occupied_array.back() == space):
			return occupied_spaces[space]
	
	return false

# returns set of legal spaces the Pawn in question can move
func pawn_mobility(piece, current_space):
	var pawn_mobility_set = []
	var direction = 1
	var second_seventh_rank = 2
	
	if (piece.parity): 
		direction = -1
		second_seventh_rank = '7'
	
	var space_ahead = current_space[0] + (char(ord(current_space[1]) + (1 * direction)))
	var two_spaces_ahead = space_ahead[0] + (char(ord(space_ahead[1]) + (1 * direction)))
	
	# if space ahead is not occupied
	if (!is_occupied(space_ahead)):
		# de(in)crement rank 
		pawn_mobility_set.push_back(space_ahead)
		
		#  pawns can move twice instead of once, if on the seventh(second) rank
		#  pawn can only move twice if it could also move once (so this check is inside moveonce check)
		if (current_space.ends_with(second_seventh_rank)):
			if (!is_occupied(two_spaces_ahead)):
				pawn_mobility_set.push_back(two_spaces_ahead)
	
	return pawn_mobility_set



func knight_mobility(piece, current_space):
	var knight_mobility_set = []
	
	var file_offset = [-1, 1, 2, 2, 1, -1, -2, -2]
	var rank_offset = [2, 2, 1, -1, -2, -2, -1, 1]
	
	for filerank in range(0, file_offset.size(), 1):
		var considered_space = (char(ord(current_space[0]) + \
		file_offset[filerank])) + (char(ord(current_space[1]) + rank_offset[filerank]))
		if (!is_occupied(considered_space)):
			knight_mobility_set.push_back(considered_space)
	
	return knight_mobility_set



func bishop_mobility(piece, current_space):
	var bishop_mobility_set = []
	
	# calculate all 4 diagonals starting from the bishops space
	for orientation in range(0,4):
		for n in range(1, 8):
			
			# controls which diagonal to check, out of the 4
			var file_offset = 1
			var rank_offset = 1
			if (orientation == 1 or orientation == 2): file_offset = - 1
			if (orientation == 0 or orientation == 1): rank_offset = -1
			
			var next_space = ((char(ord(current_space[0]) + (n * file_offset))) + (char(ord(current_space[1]) + (n * rank_offset))))
			var stop_looking = false
			if (is_occupied(next_space)): stop_looking = true
			if (stop_looking): break
			bishop_mobility_set.push_back(next_space)
	
	return bishop_mobility_set


func rook_mobility(piece, current_space):
	var rook_mobility_set = []
	
	# calculate all 4 diagonals starting from the bishops space
	for orientation in range(0,4):
		for n in range(1, 8):
			
			# controls which diagonal to check, out of the 4
			var file_offset = 1
			var rank_offset = 1
			
			# increment the rank / file only
			if (orientation == 0): file_offset = 0
			if (orientation == 1): rank_offset = 0
			if (orientation == 2):
				file_offset = 0
				rank_offset = -1
			if (orientation == 3):
				file_offset = -1
				rank_offset = 0
			
			
			var next_space = ((char(ord(current_space[0]) + (n * file_offset))) + (char(ord(current_space[1]) + (n * rank_offset))))
			var stop_looking = false
			if (is_occupied(next_space)): stop_looking = true
			if (stop_looking): break
			rook_mobility_set.push_back(next_space)
	
	return rook_mobility_set


func queen_mobility(piece, current_space):
	var queen_mobility_set = []
	# a queen can move anywhere a bishop or a rook could
	queen_mobility_set += bishop_mobility(piece, current_space)
	queen_mobility_set += rook_mobility(piece, current_space)
	return queen_mobility_set



func king_mobility(piece, current_space):
	var king_mobility_set = []
	
	var file_offset = [1, 1, -1, -1, 0, 0, 1, -1]
	var rank_offset = [1, -1, 1, -1, 1, -1, 0, 0]
	
	for filerank in range(0, file_offset.size(), 1):
		var considered_space = (char(ord(current_space[0]) + \
		file_offset[filerank])) + (char(ord(current_space[1]) + rank_offset[filerank]))
		if (!is_occupied(considered_space)):
			king_mobility_set.push_back(considered_space)
	return king_mobility_set



# trim off the moves that are illegal or off board (also illegal)
func trim_moves(moves: Array, piece, current_space: String):
	
	# trim the off-board moves
	for index in range(moves.size() - 1, -1, -1):
		var move = moves[index]
		if (ord(move[0]) < ord('A')) or (ord(move[0]) > ord('H')) or \
		(ord(move[1]) < ord('1')) or (ord(move[1]) > ord('8')) or \
		(move == current_space):
			moves.erase(move)
	return moves
	pass

# returns the set of moves that a piece could make
func consult_piece_mobility(piece, current_space):
	var piece_mobility_set = []
	
	if (piece.name.begins_with("Pawn")):
		piece_mobility_set = pawn_mobility(piece, current_space)
	if (piece.name.begins_with("Knight")): 
		piece_mobility_set = knight_mobility(piece, current_space)
	if (piece.name.begins_with("Bishop")):
		piece_mobility_set = bishop_mobility(piece, current_space)
	if (piece.name.begins_with("Rook")):
		piece_mobility_set = rook_mobility(piece, current_space)
	if (piece.name.begins_with("Queen")):
		piece_mobility_set = queen_mobility(piece, current_space)
	if (piece.name.begins_with("King")):
		piece_mobility_set = king_mobility(piece, current_space)
	
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
	
	# trim moves that are off board (very important!!)
	piece_mobility = trim_moves(piece_mobility, piece, p_current_space)

	print ("LEGAL MOVES FOR ", piece.name, ": ", piece_mobility)
	return piece_mobility





# Called when the node enters the scene tree for the first time.
func _ready():
	
	update_spaces_dictionary()
	
	pass
