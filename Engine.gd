extends "res://Rules.gd"




# Called when the node enters the scene tree for the first time.
func _ready():
	print (castling_rights)




func get_list_of_legal_moves():
	
	var parity = get_parent().get_node("Rules").active_color
	
	# piece, string
	var board_moves = []
	
	for piece in get_parent().get_node("Rules/Board/AllPieces").get_children():
		if (piece.parity == parity):
			var piece_moves = get_parent().get_node("Rules").get_legal_spaces(piece)
			
			for piece_move in piece_moves:
				board_moves.push_back([piece, piece_move])
	
	return board_moves


func get_cpu_move():
	
	var cpu_move = get_random_move()
	return cpu_move








"""
engines
"""

func get_random_move():
	var legal_moves = get_list_of_legal_moves()
	if (legal_moves.size() > 1):
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var random_variable = rng.randi_range(0, legal_moves.size() - 1)
		return legal_moves[random_variable]
	else:
		return false
