extends Node
# contains game rules
# map of square names to pixel locations

var squares = {}

# return "B4" - > (123,123)
func calculateSquareCoords(rank, file):
	var boardRect = Rect2(
		Vector2($Board.position),
		Vector2($Board.BOARD_SIZE_PX * $Board.get_scale())
	)
	var rankHeight = boardRect.size[1] / 8
	var fileLength = boardRect.size[0] / 8
	
	var squareXPos = boardRect.position[0] + (fileLength * rank)
	var squareYPos = boardRect.position[1] + (rankHeight * file)
	var squareWidth = fileLength
	var squareHeight = rankHeight
	
	return Rect2(squareXPos, squareYPos, squareWidth, squareHeight)

func createSquares():
	for rank in 8:
		for file in 8:
			var newSquare = String(char(rank + 65)) + String(char(file + 49))
			squares[newSquare] = calculateSquareCoords(rank, file)

























func loadFen(fen: String):
	print( "fen loaded" )
































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



func startPosition():
	for piece in get_node("Board/AllPieces").allPieces:
		print(squares["A1"])
		piece.get_child(1).position = (squares[findStartSquare(piece.name)]).position

































# Called when the node enters the scene tree for the first time.
func _ready():
	createSquares()
	startPosition()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
