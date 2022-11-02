extends Node




# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	"""
	Game Loop
	"""
	
	"""
	Main Menu
	"""
	$Menu.visible = true
	yield($Menu, "choose_new_game")
	
	
	"""
	Chess
	"""
	$Chess/Rules/Board.set_board_size(0.80)
	$Chess/Rules/Board.set_board_position(0.10, 0.10)
	$Chess/Rules/Board.loadFen("rnbq1k1r/pp1Pbppp/2p5/8/2B5/8/PPP1NnPP/RNBQK2R w KQ - 1 8")


func _on_Menu_choose_new_game():
	$Chess/Rules/Board.loadFen("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")


func _on_Menu_choose_cpu_move():
	var board_moves = $Chess/Engine.get_list_of_legal_moves()
	
	print ($Chess/Rules.get_active_color(), " has ", board_moves.size(), " legal moves.")
	
	#for move in board_moves:
		#print (move[0].name,": ", move[0].current_space, " - ", move[1])
