extends Node

# mother of all pieces
# contains all spritesheet info for each piece

var piece_in_hand = false

func set_piece_in_hand(piece, held):
	
	if (held == true):
		piece_in_hand = true
		piece.set_z_index(100)
	else:
		piece_in_hand = false
		piece.set_z_index(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
