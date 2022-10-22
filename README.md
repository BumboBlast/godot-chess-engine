# godot chess engine
 working on this to keep me busy

started over again again

func update_piece_sprite_rect():
func set_board_position(percentWindowW, percentWindowH):
func set_board_size(percentWindowH):
func update_board_sprite_rect():
func place_piece(piece, square: String):
func add_piece(name: String, parity: String, square: String):

func calculate_square_coords(rankFile):


pieces are scaled with the board

pieces are dynamically named correctly
func increment_name(pieceName: String):

--------------------------------------------------------------------------------

[x] piece load texture (piece)
[] make the pieces take up the whole square, AND center onto the square
[x] instance pieces (all pieces)
[x] place piece function (all pieces)
[] make collison a precise positon/size

[] event handler:
    [x] collision works
    [x] clicking works
    [x] dragging works
        [x] piece's center snaps to cursor
        [x] piece's center follows cursor
        [] can only click/drag on piece at a time
    [] dropping pieces works
        [x] piece will drop after you let go of the mouse button
        [] piece will snap onto the nearest space
        [] piece will snap back to starting space if dropped in illegal location

debugging:  


    
