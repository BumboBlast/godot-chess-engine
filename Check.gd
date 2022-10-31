extends Node



# returns true if the (color) king is in check
# considers the board state at the time of call
func is_king_in_check(parity: bool):
	
	# find where the king in question sits
	var kings_space: String
	for piece in get_parent().occupied_spaces.values():
		if (piece.name.begins_with("King")) and (parity == piece.parity):
			for sp in get_parent().occupied_spaces.keys():
				if (get_parent().occupied_spaces[sp] == piece):
					kings_space = sp
	
	# if he is being attacked, retur true (yes, he is in check)
	for piece in get_parent().occupied_spaces.values():
		
		# only enemy pieces can attack the king
		# kings cant attack eachother (so dont check if king is attacking)
		# this also resolves the recussion loop
		if (piece.parity != parity):
			var legal_set = kingless_piece_mobility(piece)
			
			for move in legal_set:
				if (move == kings_space):
					#print (" the ", piece.name, " on ", piece.current_space, " cant attack the king on ", kings_space)
					return true
	return false





# make a fake boardState to analyze
# a move is a pair of spaces
# new move removes the piece on oldsquare and replaces it onto newsquare
# returns true if next_move is legal
func suppose_next_move(old_square: String, new_square: String):
	
	# make a silly fake board state by making a new occupied_spaces_dictionary
	# for this instance only. Therefore, call "Update spaces dictionary" at the end
	# make no changes to the actual pieces in the tree 
	# so that the update call fixes the spaces dictionary 
	
	
	var piece = get_parent().is_occupied(old_square)
	if (!piece):
		print( "sorry, this move doesnt make sense,:", old_square, " to ", new_square)
		return false
	
	# move the piece (create fake board state, 1 move deep)
	get_parent().occupied_spaces.erase(old_square)
	get_parent().occupied_spaces[new_square] = piece
	
	# if this position (1 move ahead) is in check
	if (is_king_in_check(piece.parity)):
		#print("the ", piece.parity, " king is in check after moving to  ", new_square)
		get_parent().update_spaces_dictionary()
		return false
	
	# restore the current board state
	get_parent().update_spaces_dictionary()
	return true





# same as consult_piece_mobility but without checking for king
func kingless_piece_mobility(piece):
	var piece_mobility_set = []
	var current_space = piece.current_space
	
	if (piece.name.begins_with("Pawn")):
		piece_mobility_set = get_parent().get_node("PieceMobility").pawn_mobility(piece, current_space)
	if (piece.name.begins_with("Knight")): 
		piece_mobility_set = get_parent().get_node("PieceMobility").knight_mobility(piece, current_space)
	if (piece.name.begins_with("Bishop")):
		piece_mobility_set = get_parent().get_node("PieceMobility").bishop_mobility(piece, current_space)
	if (piece.name.begins_with("Rook")):
		piece_mobility_set = get_parent().get_node("PieceMobility").rook_mobility(piece, current_space)
	if (piece.name.begins_with("Queen")):
		piece_mobility_set = get_parent().get_node("PieceMobility").queen_mobility(piece, current_space)
	
	return piece_mobility_set
