extends Node



func _ready():
	
	$Rules/Board.set_board_size(0.80)
	$Rules/Board.set_board_position(0.10, 0.10)
	
	#$Rules/Board.loadFen("r1bqk1nr/pppp1ppp/2n5/2b1p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 92 1435")
	$Rules/Board.loadFen("3rkbnr/pppqp1pp/2n5/1B1pPp2/6b1/2P2N2/PP1P1PPP/RNBQ1RK1 w k f6 0 7")

	for piece in $Rules/Board/AllPieces.get_children():
		print(piece.name, " on square ", piece.current_space)
		
# calls at the top of every frame
func _process(delta):
	pass
