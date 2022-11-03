extends Node

var START_FEN = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"


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
	$Chess/Rules/Board.loadFen(START_FEN)


func _on_Menu_choose_new_game():
	$Chess/Rules/Board.loadFen(START_FEN)


func _on_Menu_choose_cpu_move():
	var board_moves = $Chess/Engine.get_list_of_legal_moves()
	
	print ($Chess/Rules.get_active_color(), " has ", board_moves.size(), " legal moves.")
	
	var cpu_turn = $Chess/Engine.get_cpu_move()
	if (!cpu_turn): return false
	var cpu_piece = cpu_turn[0]
	var cpu_old_space = cpu_piece.current_space
	var cpu_new_space = cpu_turn[1]
	$Chess/Rules/Board.place_piece(cpu_piece, cpu_new_space)
	$Chess/Rules.make_logical_move(cpu_piece, cpu_old_space, cpu_new_space)
	
	
	#for move in board_moves:
		#print (move[0].name,": ", move[0].current_space, " - ", move[1])


func _on_Menu_choose_load_fen():
	var text_fen = $Menu/VBoxContainer/FENLabel.text
	
	if (!$Chess/Rules/Board.is_legal_fen(text_fen)):
		# probably should put error code somwhere else lol
		$Menu/VBoxContainer/FENLabel.text = "Error loading FEN"
	else:
		$Chess/Rules/Board.loadFen(text_fen)
