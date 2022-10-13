extends Node2D



var boardRect

var pieces = []

"""
1. create piece nodes
"""
func instanceNode2D(name):
	#make the nodes themselves
	var piece = Node2D.new()
	piece.set_name(name)
	
	#give them sprite-nodes
	var sprite = Sprite.new()
	piece.add_child(sprite)
	sprite.set_name(name + " sprite")
	add_child(piece)
	
	pieces.push_back(piece)


func createPiece(name, amount):
	for n in amount:
		var pawnName = name + String(n)
		instanceNode2D(pawnName)

func givePiecesTextures():
	var tex = load("res://art/debugPiecesSpriteSheet1.png")
	var pieceFromSpriteSheet = Rect2(0,0,8,8)
	for p in pieces:
		p.get_child(0).set_region(1)
		p.get_child(0).set_region_rect(pieceFromSpriteSheet)
		p.get_child(0).texture = tex

"""
2a. make a list of board locations
2b. set piece textures and starting positions on the board
"""

func updateBoardRect():
	var rpos = get_node("BoardTexture").rect_position
	var rsiz = get_node("BoardTexture").rect_size
	boardRect = Rect2(rpos,rsiz)


func _on_BoardTexture_ready():
	updateBoardRect()
	pass # Replace with function body.



func calculateSquareCoords(rank, file):
	var newXpos = (rank * 7)
	var newYpos = (file * 7)
	var newWidth = (boardRect.size[1] / 7)
	var newHeight = (boardRect.size[0] / 7)
	return Rect2(newXpos, newYpos, newWidth, newHeight)
			

var squares = {}
func createSquares():
	
	for rank in 8:
		for file in 8:
			var newSquare = String(char(rank + 65)) + String(char(file + 49))
			squares[newSquare] = calculateSquareCoords(rank, file)
			#print(newSquare, ",", squares[newSquare])

func startPiecesOnSquares():
	for p in pieces:
		p.position = Vector2(100,100)
		pass # <-------------------------------------------------------------

func startBoard():
	createPiece("Pawn", 16)
	createPiece("Rook", 4)
	createPiece("Knight", 4)
	createPiece("Bishop", 4)
	createPiece("King", 2)
	createPiece("Queen", 2)
	givePiecesTextures()
	createSquares()
	startPiecesOnSquares()


# Called when the node enters the scene tree for the first time.
func _ready():
	startBoard()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

