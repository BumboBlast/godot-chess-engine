extends HBoxContainer




func _ready():
	for button in range(0, get_children().size()):
		var textures = ["Queen", "Rook", "Bishop", "Knight"]
		#loadTexture(get_child(button), textures[button])
		
