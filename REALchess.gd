extends Node



func _ready():
	
	$Rules/Board.set_board_size(0.80)
	$Rules/Board.set_board_position(0.10, 0.10)
	
	$Rules/Board.loadFen("r1bqk1nr/pppp1ppp/2n5/2b1p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 0 1")


# calls at the top of every frame
func _process(delta):
	pass
