extends Node2D



var boardRect = Rect2(0,0,0,0)
var boardScale

var pieces = []
const PIECEARTPIXELS = Vector2(7,7) #pixels
const BOARDARTPIXELS = Vector2(80,80) #pixels
var pieceSize = Vector2(7,7) #pixels

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
		var pieceName = name + String(n)
		instanceNode2D(pieceName)






























func findSpriteSheetRect(pieceName):
	var pieceParity = int(pieceName[pieceName.length() - 1])
	var spriteSize = PIECEARTPIXELS #in pixels
	if (pieceName.begins_with("Pawn")):
		if (pieceParity % 2 == 0):
			return Rect2(spriteSize[0] * 0, spriteSize[0] * 0, spriteSize[0], spriteSize[1])
		else:
			return Rect2(spriteSize[0] * 0, spriteSize[0] * 1, spriteSize[0], spriteSize[1])
	if (pieceName.begins_with("King")):
		if (pieceParity % 2 == 0):
			return Rect2(spriteSize[0] * 1, spriteSize[0] * 0, spriteSize[0], spriteSize[1])
		else:
			return Rect2(spriteSize[0] * 1, spriteSize[0] * 1, spriteSize[0], spriteSize[1])
	if (pieceName.begins_with("Bishop")):
		if (pieceParity % 2 == 0):
			return Rect2(spriteSize[0] * 2, spriteSize[0] * 0, spriteSize[0], spriteSize[1])
		else:
			return Rect2(spriteSize[0] * 2, spriteSize[0] * 1, spriteSize[0], spriteSize[1])
	if (pieceName.begins_with("Knight")):
		if (pieceParity % 2 == 0):
			return Rect2(spriteSize[0] * 3, spriteSize[0] * 0, spriteSize[0], spriteSize[1])
		else:
			return Rect2(spriteSize[0] * 3, spriteSize[0] * 1, spriteSize[0], spriteSize[1])
	if (pieceName.begins_with("Rook")):
		if (pieceParity % 2 == 0):
			return Rect2(spriteSize[0] * 4, spriteSize[0] * 0, spriteSize[0], spriteSize[1])
		else:
			return Rect2(spriteSize[0] * 4, spriteSize[0] * 1, spriteSize[0], spriteSize[1])
	if (pieceName.begins_with("Queen")):
		if (pieceParity % 2 == 0):
			return Rect2(spriteSize[0] * 5, spriteSize[0] * 0, spriteSize[0], spriteSize[1])
		else:
			return Rect2(spriteSize[0] * 5, spriteSize[0] * 1, spriteSize[0], spriteSize[1])

































func findStartSquare(pieceName):
	var regex = RegEx.new()
	regex.compile("\\d+")
	var pieceCounter = regex.search(pieceName).get_string()
	pieceCounter = int(pieceCounter)
	
	
	if (pieceName.begins_with("Pawn")):
		if (pieceCounter % 2 ==  0):
			return String(char((pieceCounter / 2) + 65) + "2")
		else:
			return String(char(((pieceCounter - 1) / 2) + 65) + "7")
	
	if (pieceName.begins_with("Knight")):
		if (pieceCounter == 0): return "B1"
		if (pieceCounter == 1): return "B8"
		if (pieceCounter == 2): return "G1"
		if (pieceCounter == 3): return "G8"
		
	if (pieceName.begins_with("Bishop")):
		if (pieceCounter == 0): return "C1"
		if (pieceCounter == 1): return "C8"
		if (pieceCounter == 2): return "F1"
		if (pieceCounter == 3): return "F8"
	
	if (pieceName.begins_with("Rook")):
		if (pieceCounter == 0): return "A1"
		if (pieceCounter == 1): return "A8"
		if (pieceCounter == 2): return "H1"
		if (pieceCounter == 3): return "H8"
		
	if (pieceName.begins_with("King")):
		if (pieceCounter == 0): return "E1"
		if (pieceCounter == 1): return "E8"

	if (pieceName.begins_with("Queen")):
		if (pieceCounter == 0): return "D1"
		if (pieceCounter == 1): return "D8"




func givePiecesTextures():
	var tex = load("res://art/debugPiecesSpriteSheet1.png")
	var pieceScale = (boardRect.size[0] / 8) / pieceSize[0]  # makes pieces exactly the same size as board squares
	# idk why that workdd
	
	for p in pieces:
		var pieceFromSpriteSheet = findSpriteSheetRect(p.name)
		
		p.get_child(0).set_region(1)
		p.get_child(0).set_region_rect(pieceFromSpriteSheet)
		p.get_child(0).texture = tex
		p.get_child(0).centered = 0
		p.get_child(0).set_scale(Vector2(pieceScale , pieceScale))
		pieceSize = PIECEARTPIXELS * (pieceScale)























"""
2a. make a list of board locations
2b. set piece textures and starting positions on the board
"""

func updateBoardRect():
	var windowSize = get_viewport().size
	var centerWindow = Vector2(windowSize[0] / 2, windowSize[1] / 2)
	get_node("BoardTexture").centered = 0

	#scale, so that the board height is 80% of the screen height
	var newHeight = 0.80 * windowSize[1]
	var newScale = newHeight / get_node("BoardTexture").get_rect().size[1]
	get_node("BoardTexture").set_scale(Vector2(newScale, newScale))
	
	#transform center of board into center of screen
	get_node("BoardTexture").position[1] = windowSize[1] * 0.14	#14% from the top
	get_node("BoardTexture").position[0] = windowSize[0] * 0.5 	#50% from the bottom
	
	#update these class elements
	boardScale = newScale
	boardRect.position = get_node("BoardTexture").position
	boardRect.size = Vector2(
		get_node("BoardTexture").get_rect().size[0] * boardScale,
		get_node("BoardTexture").get_rect().size[1] * boardScale
	)



func _on_BoardTexture_ready():
	updateBoardRect()
	pass # Replace with function body.

func myfunc():
	print("Resizing: ", get_viewport().size)





























func placePieceOnSquare(piece, squareName):
	var squareAnchor = squares[squareName]
	var difLength = (squareAnchor.size[0] - pieceSize[0]) / 2
	var difHeight = (squareAnchor.size[1] - pieceSize[1]) / 2
	var centeredAnchor = Vector2(
		squareAnchor.position[0] + difLength,
		squareAnchor.position[1] + difHeight
	) 
	piece.position = centeredAnchor

func calculateSquareCoords(rank, file):
	var rankHeight = boardRect.size[1] / 8
	var fileLength = boardRect.size[0] / 8
	
	var squareXPos = boardRect.position[0] + (fileLength * rank)
	var squareYPos = boardRect.position[1] + (rankHeight * file)
	var squareWidth = fileLength
	var squareHeight = rankHeight
	
	return Rect2(squareXPos, squareYPos, squareWidth, squareHeight)
			

var squares = {}
func createSquares():
	
	for rank in 8:
		for file in 8:
			var newSquare = String(char(rank + 65)) + String(char(file + 49))
			squares[newSquare] = calculateSquareCoords(rank, file)
			#print(rank, file, newSquare, ",", squares[newSquare])

func startPiecesOnSquares():
	for p in pieces:
		placePieceOnSquare(p, findStartSquare(p.name))



















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
	get_tree().get_root().connect("size_changed", self, "myfunc")
	startBoard()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

