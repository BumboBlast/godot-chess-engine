extends Node

onready var boardRect = get_parent().boardRect
var pieceSize = Vector2(7,7) #pixels

const PIECEARTPIXELS = Vector2(7,7)


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
		var pieceName = name + String(n)
		instanceNode2D(pieceName)


func instancePieces():
	createPiece("Pawn", 16)
	createPiece("Rook", 4)
	createPiece("Knight", 4)
	createPiece("Bishop", 4)
	createPiece("King", 2)
	createPiece("Queen", 2)


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




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
