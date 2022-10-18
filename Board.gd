extends Sprite
# sprite has a position and a scale
# size is art pixel size * scale
# pass the scale in resize functions, instead of size






"""
	Board Properties
"""
onready var spriteRect = Rect2(
	self.get_position(),
	self.texture.get_size() * self.get_scale()
)





"""
	Board methods
"""

func update_board_sprite_rect():
	self.spriteRect = Rect2(
		self.get_position(),
		self.texture.get_size() * self.get_scale()
	)





# calculate scale for new board size
# new pixels = old pixels * new scale
func set_board_size(percentWindowH):
	var nowSize = self.texture.get_size()
	var newSize = get_viewport().get_size()[1] * percentWindowH
	newSize = Vector2(newSize, newSize)
	var newScale = newSize / nowSize
	
	self.set_scale(newScale)
	update_board_sprite_rect()





# allign right board edge percent window away from right window edge 
# allign bottom board edge percent window away from bottom window edge
func set_board_position(percentWindowW, percentWindowH):
	self.centered = false
	
	var windowWidth = get_viewport().get_size()[0] #in pixels
	var windowHeight = get_viewport().get_size()[1] #in pixels
	var boardWidth = self.get_texture().get_size()[0] * self.get_scale()[0] #in pixels
	var boardHeight = self.get_texture().get_size()[1] * self.get_scale()[0] #in pixels
	
	# distance between window right/bottom edge and board right/bottom edge, in pixels
	# as calculation of percent of window width/height
	var percentWindowDiffW = windowWidth * percentWindowW
	var percentWindowDiffH = windowHeight * percentWindowH
	
	var newPos = Vector2(
		windowWidth - (boardWidth + (percentWindowDiffW)),
		windowHeight - (boardHeight + (percentWindowDiffH))	
	)
	self.set_position(newPos)





func _ready():
	
	set_board_size(0.80)
	set_board_position(0.10, 0.10)
	
	pass


