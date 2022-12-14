extends Area2D
# contains all the mthods and properties each piece might carry
# AllPieces will contain specfic nuances about difference bettwen pieces 
# (names, where they are on the spritesheet)




"""
	Piece Properties
"""


# stores the boundry of the sprite
var sprite_rect = Rect2(
	0, 0, 0, 0
)

# false = light, true = dark
# default true/dark
var parity = true


func get_color():
	if (parity): 
		return ("black")
	else: 
		return ("white")

# boolean stores whether or not the piece in question is draggable
var selected = false

# boolean stores when the piece has just been let go
var just_dropped = false

# stores space which the piece will lerp into when dropped
var rest_point: Vector2

# array of strings storing list of legal spaces that a piece in question can land
var legal_spaces = []




var current_space: String
var previous_space: String



"""
	Piece methods
"""







func find_spritepath(pieceName: String):
	
	if (parity):
		if ("Pawn" in pieceName): return "res://art/chess/pixel art pieces 1/pawn1.png"
		if ("Knight" in pieceName): return "res://art/chess/pixel art pieces 1/knight1.png"
		if ("Bishop" in pieceName): return "res://art/chess/pixel art pieces 1/bishop1.png"
		if ("Rook" in pieceName): return "res://art/chess/pixel art pieces 1/rook1.png"
		if ("King" in pieceName): return "res://art/chess/pixel art pieces 1/king1.png"
		if ("Queen" in pieceName): return "res://art/chess/pixel art pieces 1/queen1.png"
	if ("Pawn" in pieceName): return "res://art/chess/pixel art pieces 1/pawn.png"
	if ("Knight" in pieceName): return "res://art/chess/pixel art pieces 1/knight.png"
	if ("Bishop" in pieceName): return "res://art/chess/pixel art pieces 1/bishop.png"
	if ("Rook" in pieceName): return "res://art/chess/pixel art pieces 1/rook.png"
	if ("King" in pieceName): return "res://art/chess/pixel art pieces 1/king.png"
	if ("Queen" in pieceName): return "res://art/chess/pixel art pieces 1/queen.png"





# update the variable storing the size of the texture
# this is used to pass to other objects incase they want it
# be sure to call this whenever you update art or like boardsizes or something
# also make sure the texture is same place as parent node! (idk why)
func update_piece_sprite_rect():
	self.sprite_rect = Rect2(
		self.get_position(),
		$PieceSprite.texture.get_size() * self.get_scale()
	)
	# node and sprite should share same coords (weird)





func loadTexture():
	
	var spritepath = find_spritepath(self.name)
	
	$PieceSprite.texture = load(spritepath)
	#board scale
	var board_scale = get_parent().get_parent().get_scale()
	var board_square_px = get_parent().get_parent().texture.get_size()[0] / 8
	var piece_px = $PieceSprite.texture.get_size()[0]
	
	var new_scale = (board_scale * board_square_px ) / (piece_px )

	self.set_scale(new_scale)
	update_piece_sprite_rect()





func is_in_rect(point: Vector2, rect: Rect2):

	# if point is beyond top-left corner
	if (point[0] > rect.position[0]):
		if (point[1] > rect.position[1]):
			
			# if point is before bottom-right corner
			if (point[0] < rect.position[0] + rect.size[0]):
				if (point[1] < rect.position[1] + rect.size[1]):
					return true
	return false




"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Event Handlers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

# only captures input events with concern to the collision node
func _on_Piece_input_event(viewport, event, shape_idx):
	
	#if clicked
	if (Input.is_action_pressed("ui_left_mouse")):
		
		if (get_parent().get_parent().get_parent().next_move_ready):
		
			#only pick up piece of active color
			if (get_color() == get_parent().get_parent().get_parent().get_active_color()):
			
				#if no piece in hand
				if (get_parent().piece_in_hand == false):
					
					# can only hold one piece at once
					get_parent().set_piece_in_hand(self, true)
					
					# after click, want piece's CENTER to SNAP to mouse positon
					global_position = get_global_mouse_position() - (self.sprite_rect.size / 2)
					
					# calculate list of spaces legal for the piece to land
					# rules node
					legal_spaces = get_parent().get_parent().get_parent().get_legal_spaces(self)
					
					# stores the last place the piece was picked up (only stores it once)
					# only can pick up one piece at a time
					if (self.selected == false):
						
						# picks up the piece
						self.selected = true






# captures all input events
func _input(event):
	if (event is InputEventMouseButton):
		
		# if button is held
		if (self.selected == true):
			
			# if button is let go
			if (event.button_index == BUTTON_LEFT and not event.pressed):
				
				self.just_dropped = true
				
				# can hold a new piece
				get_parent().set_piece_in_hand(self, false)
				
				# check to see if cursor (piece center) is hovering a legal space
				for space in legal_spaces:
					var space_rect = get_parent().get_parent().get_parent().get_node("Board").calculate_square_rect(space)
					if (is_in_rect(get_global_mouse_position(), space_rect)):
							
						# piece will lerp into the new rest zone
						self.rest_point = space_rect.position
						
						# the array of legal spaces will be rebuilt when a new piece is clicked
						legal_spaces.clear()
						
						# tell the physics loop to stop dragging the piece (drop and  then snap)
						self.selected = false
						
						# legally place the piece (in the physics loop)
						self.previous_space = current_space
						self.current_space = space
						
						# updates board_state and score
						get_parent().get_parent().get_parent().make_logical_move(self, previous_space, current_space)
						
						return
				
				# piece will lerp into old rest zone (before update)
				# since this is only updated at release of mouse button
				self.rest_point = self.sprite_rect.position
				self.selected = false





func _physics_process(delta):
	
	# if piece is clicked (dragged)
	if (selected == true):
		
		# 25 * delta fixes the movement to the frame rate
		# the center follows the cursor
		# lerping is finding the weighted average point 
		global_position = lerp(global_position, get_global_mouse_position() - (self.sprite_rect.size / 2), 25 * delta)
	
	
	# if piece has just been let go
	if (just_dropped == true):
		
		# if sprite is lerping pretty close to the square, snap it
		var ten_pixels_away = Rect2(
			self.rest_point[0] - 5, # 5 pixels left
			self.rest_point[1] - 5, # 5 pixels up
			10, # 5 pixels right
			10 # 5 pixels down
		)
		if (is_in_rect(global_position, ten_pixels_away)):
			# physically moves the pieceSprite to the space in question
			get_parent().get_parent().place_piece(self, current_space)
			
			
			# need a way to logically move the piece to the space in question
			
			
			# this line is redundant and im pretty sure i can delete it
			update_piece_sprite_rect()
			self.just_dropped = false
			
		
		# piece lerps until its close enough to snap
		global_position = lerp(global_position, rest_point,  25 * delta)





# Called when the node enters the scene tree for the first time.
func _ready():
	

	pass # Replace with function body.






