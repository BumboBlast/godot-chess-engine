extends Node
# contains game rules
# map of square names to pixel locations





# uses the piece and board state to calculate list of legal spaces
# does not consider coordinates. Only file/ rank
# should be able to return a list
func get_legal_spaces(piece):
	return "C5"


# Called when the node enters the scene tree for the first time.
func _ready():
	print ('rules ready')
	pass
