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
    [] refactor is_in_rect to distance_to()
    [x] pieces are drawn to the top
        [] make z indexes more explicit
    [x] pieces now keep track of what space they are on (i can iterate pieces in the tree)
    [x] piees now keep track of what space they were on before being legally moved
    [] added a score card (keeps track of move order)


    [] event handler:
        [x] collision works
        [x] clicking works
        [x] dragging works
            [x] piece's center snaps to cursor
            [x] piece's center follows cursor
            [x] can only click/drag on piece at a time
        [x] dropping pieces works
            [x] piece will drop after you let go of the mouse button
            [x] piece will snap onto the nearest legal space
            [x] piece will snap back to starting space if dropped in illegal location

    [] boardState:
        [] calculate list of legal spaces each time a piece is picked up
            [] make get_legal_spaces() be able to return an array of strings

    [] FEN:
        [x]Piece Placement - 
            [x] only add pieces in the middle portion
        [x] Active Color
        [x] Castling Rights
        [x] Possible En Passant Targets
        [x] Halfmove Clock
        [] REFACTOR so it isnt a huge stinky pile

    [] rules:
        [x] legal spaces returns list, and its interpreted correctly
        [x] calulcate legal moves based on piece held by consulting list of rules
        [x] refine legal moves list based upon other pieces on the board
        [] refine legal moves list based upon other things (en passant, castling, stalemtn, check)
            [] pawn rules
                [x] move one space
                [x] move pawn 2 spaces if on second/ seventh rank
                [] enpassant
                [] promoting
                [] capturing
            [] knight rules
                [x] normal move
                [] capturing
            [] bishop rules
                [x] normal move
                [] capturing
            [] rook rules
                [x] normal move
                [] capturing
            [] king rules
                [x] normal move
                [] capturing
            [] queen rules
                [x] normal move
                [] capturing

        
debugging:  

    BUG in Piece and Board:

    Piece: when changing how legal_spaces is updated
        legal_spaces = get_legal_spaces  instad of legal_spaces.append(get_legal_spaces)
    then game crashes with error from
    Board's calculate boardsquare
    ( i think i fixed it by making sure get_legal_spaces returns an array)

    BUG:
        pieces can move off board. (there are legal spaces outside the board B9, etc)

    Bug: knight moves off board when at Square A1. SOLVED: ranges are [,)

    
