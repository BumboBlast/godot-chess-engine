extends Node
# contains game rules
# map of square names to pixel locations

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
	
	# rebuild dictionary with updated
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
