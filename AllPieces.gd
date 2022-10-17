extends Node

# mother of all pieces
# contains all spritesheet info for each piece

var allPieces = []
var scene = load("res://Piece.tscn")

func createPiece(pieceName: String, amount: int, pos: Vector2):
	for n in amount:
		var newPiece = scene.instance()
		
		newPiece.name = pieceName + String(n)
		newPiece.get_child(1).name = newPiece.name + "Sprite"
		newPiece.set_position(pos)
		newPiece.get_child(1).scale = get_parent().scale # CVHANGE THIS SO SAME SIZE AS SQUARE
		newPiece.loadTexture(findSpriteSheetRect(newPiece.name))

		newPiece.visible = true
		add_child(newPiece)
		
		allPieces.push_back(newPiece)

func findSpriteSheetRect(pieceName: String):
	
	var pieceParity = int(pieceName[pieceName.length() - 1])
	var spriteSize =  7 #in pixels
	
	#	offset to locate the sprite from the spritesheet
	# 	will be multiplied by how many sprites over it is located
	# 	its a square so only one dimension is used
	var shoffx = spriteSize
	
	if (pieceName.begins_with("Pawn")):
		if (pieceParity % 2 == 0):
			return Rect2(shoffx * 0, shoffx * 0, shoffx, shoffx)
		else:
			return Rect2(shoffx * 0, shoffx * 1, shoffx, shoffx)
	if (pieceName.begins_with("King")):
		if (pieceParity % 2 == 0):
			return Rect2(shoffx * 1, shoffx * 0, shoffx, shoffx)
		else:
			return Rect2(shoffx * 1, shoffx * 1, shoffx, shoffx)
	if (pieceName.begins_with("Bishop")):
		if (pieceParity % 2 == 0):
			return Rect2(shoffx * 2, shoffx * 0, shoffx, shoffx)
		else:
			return Rect2(shoffx * 2, shoffx * 1, shoffx, shoffx)
	if (pieceName.begins_with("Knight")):
		if (pieceParity % 2 == 0):
			return Rect2(shoffx * 3, shoffx * 0, shoffx, shoffx)
		else:
			return Rect2(shoffx * 3, shoffx * 1, shoffx, shoffx)
	if (pieceName.begins_with("Rook")):
		if (pieceParity % 2 == 0):
			return Rect2(shoffx * 4, shoffx * 0, shoffx, shoffx)
		else:
			return Rect2(shoffx * 4, shoffx * 1, shoffx, shoffx)
	if (pieceName.begins_with("Queen")):
		if (pieceParity % 2 == 0):
			return Rect2(shoffx * 5, shoffx * 0, shoffx, shoffx)
		else:
			return Rect2(shoffx * 5, shoffx * 1, shoffx, shoffx)


func intializeAllPieces():
	var defaultPos =  Vector2(100,100)
	createPiece("Pawn", 16, defaultPos)
	createPiece("Knight", 4, defaultPos)
	createPiece("Bishop", 4, defaultPos)
	createPiece("Rook", 4, defaultPos)
	createPiece("King", 2, defaultPos)
	createPiece("Queen", 2, defaultPos)
	
	print(allPieces[10].name, allPieces[10].position, allPieces[10].get_child(1).visible)

# Called when the node enters the scene tree for the first time.
func _ready():
	intializeAllPieces()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
