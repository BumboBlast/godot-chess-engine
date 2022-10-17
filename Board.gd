extends Sprite
# sprite has a position and a scale
# size is art pixel size * scale
# pass the scale in resize functions, instead of size

onready var BOARD_SIZE_PX = self.get_rect().size # vector2 in pixels
onready var boardSizeScaled = BOARD_SIZE_PX * self.get_scale() # dont mutate please ):
onready var windowSize = get_viewport().size


# call this to resize the board
func updateBoard(boardRect: Rect2):
	self.position = boardRect.position
	self.set_scale(boardRect.size) #scale

# set intial postition of the board
func initializeBoard():
	self.centered = 0
	
	# want board to be as tall as 80 % of the window
	var newScale = windowSize[1] * 0.80 / BOARD_SIZE_PX[0]
	
	# want the left edge of the board to be centered (for now)
	# board should be centered in height (10 % of the screen height on either side)
	var xPos = windowSize[0] * 0.50
	var yPos = windowSize[1] * 0.10
	
	var newRect = Rect2(
		xPos,
		yPos,
		newScale,
		newScale
	)
	updateBoard(newRect)

# Called when the node enters the scene tree for the first time.
func _ready():
	initializeBoard()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
