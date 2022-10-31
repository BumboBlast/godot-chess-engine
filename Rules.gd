extends Node
# contains game rules


#indicates which side moves next
var active_color: bool

var next_move_ready: bool


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
var enpassant_legal = false
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
var black_in_check: bool



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








# returns the piece if occupied, else returns false if empty
func is_occupied(space):
	
	for sp in occupied_spaces:
		if (sp == space):
			return occupied_spaces[space]
	
	return false
















func is_space_offboard(space: String):
	if (ord(space[0]) < ord('A')) or (ord(space[0]) > ord('H')) or \
	(ord(space[1]) < ord('1')) or (ord(space[1]) > ord('8')):
		return true
	return false






# trim off the moves that are illegal or off board (also illegal)
func trim_off_board_moves(moves: Array, piece):
	
	# trim the off-board moves
	for index in range(moves.size() - 1, -1, -1):
		var move = moves[index]
		if is_space_offboard(move) or (move == piece.current_space):
			moves.erase(move)
	return moves
	pass







func trim_violate_check_moves(moves: Array, piece):
	
	# trim the moves that violate check
	for index in range(moves.size() - 1, -1, -1):
		var move = moves[index]
		
		# if the move in question is illegal 
		if (!$Check.suppose_next_move(piece.current_space, move)):
			moves.erase(move)
	return moves
	pass








# returns the set of moves that a piece could make
func consult_piece_mobility(piece):
	var piece_mobility_set = []
	var current_space = piece.current_space
	
	if (piece.name.begins_with("Pawn")):
		piece_mobility_set = $PieceMobility.pawn_mobility(piece, current_space)
	if (piece.name.begins_with("Knight")): 
		piece_mobility_set = $PieceMobility.knight_mobility(piece, current_space)
	if (piece.name.begins_with("Bishop")):
		piece_mobility_set = $PieceMobility.bishop_mobility(piece, current_space)
	if (piece.name.begins_with("Rook")):
		piece_mobility_set = $PieceMobility.rook_mobility(piece, current_space)
	if (piece.name.begins_with("Queen")):
		piece_mobility_set = $PieceMobility.queen_mobility(piece, current_space)
	if (piece.name.begins_with("King")):
		piece_mobility_set = $PieceMobility.king_mobility(piece, current_space)
	
	return piece_mobility_set







func last_move_was_enpassant(piece, new_space):
	if (piece):
		if ("Pawn" in piece.name):
			if (new_space == enpassant_target):
				return true
	return false


func capture_pawn_enpassant(piece, new_space):
	var rank_offset = 1
	if (piece.parity): rank_offset = -1
	var pawn_behind_space = new_space[0] + char(ord(new_space[1]) - rank_offset)
	var pawn_behind_piece = is_occupied(pawn_behind_space)
	if (pawn_behind_piece):
		pawn_behind_piece.free()
		enpassant_legal = false
	else:
		print( "error finding that pawn")



func was_last_move_pawn_promote(piece, new_space):
	if ("Pawn" in piece.name):
		var last_rank = '8'
		if (piece.parity): last_rank = '1'
		if (new_space[1] == last_rank):
			return true
	return false






func promote_pawn(piece, new_space):
	for this_piece in $Board/AllPieces.get_children():
		if (this_piece == piece):
			var parity = this_piece.parity
			print( "chosen color is: ", parity)
			var chosen_promotion = yield(get_parent().get_child(1).handle_promote_menu(), "completed")
			$Board.add_piece(chosen_promotion, parity, new_space)
			this_piece.queue_free()
			update_spaces_dictionary()
			next_move_ready = true





# updates the board state and score with each real, legal move
func make_logical_move(piece, old_space: String, new_space: String):
	
	next_move_ready = false
	
	var parity = "White"
	if (piece.parity): parity = "Black"
	var last_move = score.back()
	score.push_back([parity + piece.name, old_space, new_space])
	
	# if castled, move the rook and then disable castling for that color
	if ("King" in piece.name):
		var just_castled = $Castling.just_castled(piece.name, old_space, new_space)
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
	
	
	# if this move was an enpassant:
	if (enpassant_legal):
		if (last_move_was_enpassant(piece, new_space)):
			# capture the pawn in question
			capture_pawn_enpassant(piece, new_space)
		else: 
			enpassant_legal = false
			enpassant_target = ""
	
	# if this move made enpassant legal 
	if ("Pawn" in piece.name):
		# if the pawn moved two spaces
		if (abs(ord(old_space[1]) - ord(new_space[1])) == 2):
			# if there is any pawn is one file away from the last_move's pawn's current space
			for pawn in $Board/AllPieces.get_children():
				if ("Pawn" in pawn.name):
					if (abs(ord(pawn.current_space[0]) - ord(new_space[0])) == 1):
						if (pawn.current_space[1] == new_space[1]):
							# only one en passant target can exist at once
							var rank_offset = 1
							if (pawn.parity): rank_offset = -1
							var space_before = new_space[0] + char(ord(new_space[1]) + rank_offset)
							enpassant_legal = true
							enpassant_target = space_before
							print( "en passant is now legal ", enpassant_target)
	
	
	
	# if pawn is at last rank (promote)
	if (was_last_move_pawn_promote(piece, new_space)):
		promote_pawn(piece, new_space)
	else: next_move_ready = true
	
	# if move resulted in a capture
	var occupying_piece = is_occupied(new_space)
	if (occupying_piece):
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
	if ($Check.is_king_in_check(active_color)):
		print (get_active_color(), " is in check")
		if (active_color):
			black_in_check = true
		else:
			white_in_check = true
	else:
		if (active_color):
			black_in_check = false
		else:
			white_in_check = false







# uses the piece and board state to calculate list of legal spaces
# does not consider coordinates. Only file/ rank
# should be able to return a list
func get_legal_spaces(piece):
	
	# list of spaces a piece could move if the board were empty
	var piece_mobility = consult_piece_mobility(piece)
	
	# trim moves that are off board (very important!!)
	piece_mobility = trim_off_board_moves(piece_mobility, piece)
	
	#trim moves that violate check
	piece_mobility = trim_violate_check_moves(piece_mobility, piece)

	print ("LEGAL MOVES FOR ", piece.name, ": ", piece_mobility)
	return piece_mobility



# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	
	pass
