extends "res://src/Chess/Rules.gd"
# idont think this is necessary


# returns true if the spaces between the param spaces (non inclusive) are empty
func spaces_between_are_clear(kingspace: String, rookspace: String):
	
	# only consider the cases where king and rook on the same rank
	if (kingspace[1] != rookspace[1]): return false
	
	var kingspace_file = ord(kingspace[0])
	var rookspace_file = ord(rookspace[0])
	var spaces_from_king = abs(kingspace_file - rookspace_file)
	var direction = 1
	if (kingspace_file > rookspace_file): direction = -1
	
	for i in range(1, spaces_from_king):
		var offset = i * direction
		var check_this_space = char(ord(kingspace[0]) + offset) + kingspace[1]
		if (get_parent().is_occupied(check_this_space)): return false
		if (!get_parent().get_node("Check").suppose_next_move(kingspace, check_this_space)): return false
	
	return true





# returns king's castling target squares to be appended to legal spaces
# casling rights boolean will be updated after each move in board_state func
func try_castling(piece, current_space):
	
	var castling_targets = ["G8", "C8", "G1", "C1"]
	var valid_targets = []
	# check for occupied spaces, between the new target squares here # 
	
	var rook_spaces = ["H8", "A8", "H1", "A1"]
	
	# check the correct color king for castling eligibility
	for corner in [0, 1, 2, 3]:
		# if castling is legal for this rook
		if (get_parent().castling_rights[corner]):
			# if no pieces between the king and rook, 
			# also if these spaces arent attacked
			if (spaces_between_are_clear(current_space, rook_spaces[corner])):
				valid_targets.push_back(castling_targets[corner])
		
	#print( "castling targets:", valid_targets)
	return valid_targets






# this 1. checks if you just castled (legally or no) 2. resolves the rook
func just_castled(piecename: String, old_space: String, new_space: String):
	
	var king_moved_spaces = ord(new_space[0]) - ord(old_space[0])
	if (abs(king_moved_spaces) == 2):
		
		# return concerned rook and new rook space as [x, y]
		var old_rook_space
		var new_rook_space
		
		if (new_space == "G8"):
			old_rook_space = "H8"
			new_rook_space = "F8"
			get_parent().castling_rights[0] = false
			get_parent().castling_rights[1] = false
		if (new_space == "C8"):
			old_rook_space = "A8"
			new_rook_space = "D8"
			get_parent().castling_rights[0] = false
			get_parent().castling_rights[1] = false
		if (new_space == "G1"):
			old_rook_space = "H1"
			new_rook_space = "F1"
			get_parent().castling_rights[2] = false
			get_parent().castling_rights[3] = false
		if (new_space == "C1"):
			old_rook_space = "A1"
			new_rook_space = "D1"
			get_parent().castling_rights[2] = false
			get_parent().castling_rights[3] = false
		
		return [old_rook_space, new_rook_space]
	
	return false
