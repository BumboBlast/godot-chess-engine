extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

"""
1. create piece nodes
"""
func instanceNode2D(name):
	var Node = Node2D.new();
	Node.set_name(name)
	add_child(Node)

func createPiece(name, amount):
	for n in amount:
		var pawnName = name + String(n)
		instanceNode2D(pawnName)

func startBoard():
	createPiece("Pawn", 16)
	createPiece("Rook", 4)
	createPiece("Knight", 4)
	createPiece("Bishop", 4)
	createPiece("King", 2)
	createPiece("Queen", 2)


# Called when the node enters the scene tree for the first time.
func _ready():
	startBoard()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
