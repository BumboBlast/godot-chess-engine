extends Node
# contains game rules


#indicates which side moves next
var active_color: bool


func get_active_color():
	if (active_color == true):
		return "dark"
	else:
		return "light"




func set_active_color(color: String):
	if (color == "light"):
		active_color = false
	elif (color == "dark"):
		active_color = true
	else:
		active_color = false
		print(" error setting active color. Light chosen")



# default is no, load FEN makes it yes
var castling_rights_white_kingside = false
var castling_rights_black_kingside = false
var castling_rights_white_queenside = false
var castling_rights_black_queenside = false

# enpassant target
# can be a space or '-'
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
var spaces = {}

# create dictionary of spaces
# used in this class, and updated frequently, 
# rather than calling node tree hundreds of times
func make_spaces_dictionary_keys():
	for file in 8:
		for rank in 8:
			spaces[String(char(file + 65)) + String(char(rank + 49))] = false






# can be called everytime board state changes
func update_spaces_dictionary():
	
	# wipe dictionary
	spaces.clear()
	
	# rebuild dictionary with updated Space-piece pairings
	make_spaces_dictionary_keys()
	for piece in $Board/AllPieces.get_children():
		
		if (piece.current_space):
			spaces[piece.current_space] = piece






# generate and return a FEN for the current board state
func get_fen():
	pass





# uses the piece and board state to calculate list of legal spaces
# does not consider coordinates. Only file/ rank
# should be able to return a list
func get_legal_spaces(piece):
	return "A4"







# Called when the node enters the scene tree for the first time.
func _ready():
	
	update_spaces_dictionary()
	
	print ('rules ready')
	pass
