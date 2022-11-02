extends Node




# returns set of legal spaces the Pawn in question can move
func pawn_mobility(piece, current_space):
	
	var pawn_mobility_set = []
	var direction = 1
	var start_rank = '2'
	var last_rank = '8'
	
	if (piece.parity):
		direction = -1
		start_rank = '7'
		last_rank = '1'
	
	# concern the movement squares
	var space_ahead = current_space[0] + (char(ord(current_space[1]) + (1 * direction)))
	var two_spaces_ahead = space_ahead[0] + (char(ord(space_ahead[1]) + (1 * direction)))
	
	# concern the capture squares
	var space_ahead_left = char(ord(current_space[0]) - 1) + (char(ord(current_space[1]) + (1 * direction)))
	var space_ahead_right = char(ord(current_space[0]) + 1) + (char(ord(current_space[1]) + (1 * direction)))
	
	# piece objects
	var occupying_piece_ahead = get_parent().is_occupied(space_ahead)
	var occupying_piece_ahead_left = get_parent().is_occupied(space_ahead_left)
	var occupying_piece_ahead_right = get_parent().is_occupied(space_ahead_right)
	
	
	# if space ahead is not occupied
	if (!occupying_piece_ahead):
		# de(in)crement rank 
		pawn_mobility_set.push_back(space_ahead)
		
		#  pawns can move twice instead of once, if on the seventh(second) rank
		#  pawn can only move twice if it could also move once (so this check is inside moveonce check)
		if (current_space.ends_with(start_rank)):
			if (!get_parent().is_occupied(two_spaces_ahead)):
				pawn_mobility_set.push_back(two_spaces_ahead)
	
	# if can capture;
	if (occupying_piece_ahead_left):
		if (occupying_piece_ahead_left.parity != piece.parity):
			pawn_mobility_set.push_back(space_ahead_left)
	if (occupying_piece_ahead_right):
		if (occupying_piece_ahead_right.parity != piece.parity):
			pawn_mobility_set.push_back(space_ahead_right)
	
	# if can enpassant:
	if (get_parent().enpassant_legal):
		pawn_mobility_set.push_back(get_parent().enpassant_target)
	
	
	# if pawn could promote:
	for move in pawn_mobility_set:
		if last_rank in move:
			
			# add 3 more possiblites (of promotion)
			pawn_mobility_set.push_back(move)
			pawn_mobility_set.push_back(move)
			pawn_mobility_set.push_back(move)
			break # this break prevents infinite loops!
	
	return pawn_mobility_set



func knight_mobility(piece, current_space):
	var knight_mobility_set = []
	
	var file_offset = [-1, 1, 2, 2, 1, -1, -2, -2]
	var rank_offset = [2, 2, 1, -1, -2, -2, -1, 1]
	
	for filerank in range(0, file_offset.size(), 1):
		var considered_space = (char(ord(current_space[0]) + \
		file_offset[filerank])) + (char(ord(current_space[1]) + rank_offset[filerank]))
		
		var occupying_piece = get_parent().is_occupied(considered_space)
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
			var occupying_piece = get_parent().is_occupied(next_space)
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
			var occupying_piece = get_parent().is_occupied(next_space)
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
		
		var occupying_piece = get_parent().is_occupied(considered_space)
		if (!occupying_piece):
			king_mobility_set.push_back(considered_space)
		
		# if able to capture enemy piece
		elif (occupying_piece.parity != piece.parity):
			king_mobility_set.push_back(considered_space)
	
	# technically, no one can castle if anyone is in check
	if (!get_parent().white_in_check and !get_parent().black_in_check):
		king_mobility_set += get_parent().get_node("Castling").try_castling(piece, current_space)
	return king_mobility_set

