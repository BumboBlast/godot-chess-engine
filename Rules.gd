extends Node
# contains game rules


#indicates which side moves next
var active_color: bool


func get_active_color():
	if (active_color):
		return "black"
	else:
		return "white"




func set_active_color(color: String):
	if (color == "white"):
		active_color = false
	elif (color == "black"):
		active_color = true
	else:
		active_color = false
		print(" error setting active color. Light chosen")



# default is no, load FEN makes it yes
var castling_rights = [
	false, #H8
	false, #A8
	false, #H1
	false #A1
]

# boolean keeps track of a capture
var just_captured = false

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

"""
score[0] = white piece.name, old square, new square
score[1] = black piece.name, old square, new square
""" 
var score = []



var white_king_space: String
var black_king_space: String

var white_in_check: bool
var black_ing_check: bool



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


# returns true if spaces between rook and king are unoccupied
func spaces_between_rook_and_king_are_clear(space1: String, space2: String):

	var file1 = ord(space1[0])
	var file2 = ord(space2[0])
	var col = space1[1]
	var step = -1
	if ((file1 - file2) < 0): step = 1
	
	for f in range(file1 + step, file2, step):
		var check_this_space = char(f) + space1[1]
		if (is_occupied(check_this_space)): return false
	
	return true


# returns king's castling target squares to be appended to legal spaces
# casling rights boolean will be updated after each move in board_state func
# might need a refactor. I think the last if (Rook) is redundant
func try_castling(piece, current_space):
	
	var castling_targets = ["G8", "C8", "G1", "C1"]
	var valid_targets = []
	# check for occupied spaces, between the new target squares here # 
	
	var rook_spaces = ["H8", "A8", "H1", "A1"]
	
	for index in range(0, rook_spaces.size()):
		var corner = is_occupied(rook_spaces[index])
		if (corner):
			if (castling_rights[index]):
				if (spaces_between_rook_and_king_are_clear(rook_spaces[index], current_space)):
					if ("Rook" in corner.name):
						valid_targets.push_back(castling_targets[index])
	
	return valid_targets


# returns the piece if occupied, else returns false if empty
func is_occupied(space):
	
	for sp in occupied_spaces:
		if (sp == space):
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
	
	# concern the movement squares
	var space_ahead = current_space[0] + (char(ord(current_space[1]) + (1 * direction)))
	var two_spaces_ahead = space_ahead[0] + (char(ord(space_ahead[1]) + (1 * direction)))
	
	# concern the capture squares
	var space_ahead_left = char(ord(current_space[0]) - 1) + (char(ord(current_space[1]) + (1 * direction)))
	var space_ahead_right = char(ord(current_space[0]) + 1) + (char(ord(current_space[1]) + (1 * direction)))
	
	# piece objects
	var occupying_piece_ahead = is_occupied(space_ahead)
	var occupying_piece_ahead_left = is_occupied(space_ahead_left)
	var occupying_piece_ahead_right = is_occupied(space_ahead_right)
	
	
	# if space ahead is not occupied
	if (!occupying_piece_ahead):
		# de(in)crement rank 
		pawn_mobility_set.push_back(space_ahead)
		
		#  pawns can move twice instead of once, if on the seventh(second) rank
		#  pawn can only move twice if it could also move once (so this check is inside moveonce check)
		if (current_space.ends_with(second_seventh_rank)):
			if (!is_occupied(two_spaces_ahead)):
				pawn_mobility_set.push_back(two_spaces_ahead)
	
	# if can capture;
	if (occupying_piece_ahead_left):
		if (occupying_piece_ahead_left.parity != piece.parity):
			pawn_mobility_set.push_back(space_ahead_left)
	if (occupying_piece_ahead_right):
		if (occupying_piece_ahead_right.parity != piece.parity):
			pawn_mobility_set.push_back(space_ahead_right)

	return pawn_mobility_set



func knight_mobility(piece, current_space):
	var knight_mobility_set = []
	
	var file_offset = [-1, 1, 2, 2, 1, -1, -2, -2]
	var rank_offset = [2, 2, 1, -1, -2, -2, -1, 1]
	
	for filerank in range(0, file_offset.size(), 1):
		var considered_space = (char(ord(current_space[0]) + \
		file_offset[filerank])) + (char(ord(current_space[1]) + rank_offset[filerank]))
		
		var occupying_piece = is_occupied(considered_space)
		if (!occupying_piece):
			knight_mobility_set.push_back(considered_space)
			
		# if able to capture enemy piece
		elif (occupying_piece.parity != piece.parity):
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
			
			# break if going to run into an occupied square UNLESS its a capture
			var occupying_piece = is_occupied(next_space)
			if (occupying_piece):
				if (occupying_piece.parity != piece.parity): 
					bishop_mobility_set.push_back(next_space)
					break
				else: break
			
			bishop_mobility_set.push_back(next_space)
	
	return bishop_mobility_set


func rook_mobility(piece, current_space):
	var rook_mobility_set = []
	
	# calculate all 4 rows/columns starting from the rooks space
	for orientation in range(0,4):
		for n in range(1, 8):
			
			# controls which row/column to check, out of the 4
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
			
			# break if going to run into an occupied square UNLESS its a capture
			var occupying_piece = is_occupied(next_space)
			if (occupying_piece):
				if (occupying_piece.parity != piece.parity): 
					rook_mobility_set.push_back(next_space)
					break
				else: break
			
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
		
		var occupying_piece = is_occupied(considered_space)
		if (!occupying_piece):
			king_mobility_set.push_back(considered_space)
		
		# if able to capture enemy piece
		elif (occupying_piece.parity != piece.parity):
			king_mobility_set.push_back(considered_space)
	
	king_mobility_set += try_castling(piece, current_space)
	return king_mobility_set




func is_king_in_check(parity: bool):
	
	var kings_space = white_king_space
	if (parity): kings_space = black_king_space
	
	for piece in $Board/AllPieces.get_children():
		var legal_set = get_legal_spaces(piece)
		
		for move in legal_set:
			if (move == kings_space):
				return true
	return false




func is_space_offboard(space: String):
	if (ord(space[0]) < ord('A')) or (ord(space[0]) > ord('H')) or \
	(ord(space[1]) < ord('1')) or (ord(space[1]) > ord('8')):
		return true
	return false


# trim off the moves that are illegal or off board (also illegal)
# also take off moves that dont remove the king from check
# also take off moves that place the king in check
func trim_moves(moves: Array, piece):
	
	# trim the off-board moves
	for index in range(moves.size() - 1, -1, -1):
		var move = moves[index]
		if is_space_offboard(move) or (move == piece.current_space):
			moves.erase(move)
	return moves
	pass

# returns the set of moves that a piece could make
func consult_piece_mobility(piece):
	var piece_mobility_set = []
	var current_space = piece.current_space
	
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



func just_castled(piecename: String, old_space: String, new_space: String):
	
	var king_moved_spaces = ord(new_space[0]) - ord(old_space[0])
	if (abs(king_moved_spaces) == 2):
		
		# return concerned rook and new rook space as [x, y]
		var old_rook_space
		var new_rook_space
		
		if (new_space == "G8"):
			old_rook_space = "H8"
			new_rook_space = "F8"
			castling_rights[0] = false
			castling_rights[1] = false
		if (new_space == "C8"):
			old_rook_space = "A8"
			new_rook_space = "D8"
			castling_rights[0] = false
			castling_rights[1] = false
		if (new_space == "G1"):
			old_rook_space = "H1"
			new_rook_space = "F1"
			castling_rights[2] = false
			castling_rights[3] = false
		if (new_space == "C1"):
			old_rook_space = "A1"
			new_rook_space = "D1"
			castling_rights[2] = false
			castling_rights[3] = false
		
		return [old_rook_space, new_rook_space]
	
	return false


# updates the board state and score with each real, legal move
func make_logical_move(piece, old_space: String, new_space: String):
	var parity = "White"
	if (piece.parity): parity = "Black"
	score.push_back([parity + piece.name, old_space, new_space])
	
	# if castled, move the rook and then disable castling for that color
	if ("King" in piece.name):
		var just_castled = just_castled(piece.name, old_space, new_space)
		if (just_castled):
			$Board.place_piece(occupied_spaces[just_castled[0]], just_castled[1])
		if (piece.parity):
			black_king_space = new_space
			castling_rights[0] = false
			castling_rights[1] = false
		else:
			white_king_space = new_space
			castling_rights[2] = false
			castling_rights[3] = false
	
	# if moved rook or king, no more castling
	if ("Rook" in piece.name):
		if (old_space == "H8"): castling_rights[0] = false
		if (old_space == "A8"): castling_rights[1] = false
		if (old_space == "H1"): castling_rights[2] = false
		if (old_space == "A1"): castling_rights[3] = false
	
	
	# if move resulted in a capture
	var occupying_piece = is_occupied(new_space)
	if (occupying_piece):
		print( "made a capture ")
		for p in $Board/AllPieces.get_children():
			if p == occupying_piece: 
				
				# call piece's destructor after refactoring:
				p.free()
				break
	
	# change active color (your turn!)
	active_color = (!active_color)
	
	
	
	# keep current, the record of the board state
	update_spaces_dictionary()
	
	# this function is called AFTER making a move. 
	# so it should consider if the NEW active color is in check because of this move
	# (it will eventually be impossible to put yourself in check)
	if (is_king_in_check(active_color)):
		print (get_active_color(), " is in check")






# uses the piece and board state to calculate list of legal spaces
# does not consider coordinates. Only file/ rank
# should be able to return a list
func get_legal_spaces(piece):
	
	# list of spaces a piece could move if the board were empty
	var piece_mobility = consult_piece_mobility(piece)
	
	# trim moves that are off board (very important!!)
	# trim moves that violate check
	piece_mobility = trim_moves(piece_mobility, piece)

	#print ("LEGAL MOVES FOR ", piece.name, ": ", piece_mobility)
	return piece_mobility



# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	
	pass
