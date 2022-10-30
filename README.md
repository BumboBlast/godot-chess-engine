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


game keeps track of whos turn it is
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
    [] make rook movement (during castling) lerp
    [] make it so you actually have to click the piece
        [] right now you can click anywhere and hold down LMB until you hover a piece

    [x] make sure castling checks for all legality  
        [x] castling checks if a rook is there
        [x] castling checks castling_rights boolean
        [x] castling now checks if a rook or a king has ever moved
        [x] only consider castling for the correct color
        [x] cant castle through or out of check
    
    [x]  capturing works
        [x] turns work
        [x] pieces leave board when captured
        [x] captures only opposite color
 
    ---- 
    right now place_piece (mostly) physically moves the sprite, and is located in baord (called in piece)
    logical_move legally moves the piece , and is located in rules (called in piece)
    ----

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

        [] check
            [x] checks if king is being attacked
            [x] impossible to put yourself in check
            [x] if in check, can only make moves that escape check
            [x] cant castle (if in ) out check
            [x] cant castle through check

            [] pawn rules
                [x] move one space
                [x] move pawn 2 spaces if on second/ seventh rank
                [x] enpassant
                    [x] its buggy
                [x] promoting
                [x] capturing
            [] knight rules
                [x] normal move
                [x] capturing
            [] bishop rules
                [x] normal move
                [x] capturing
            [] rook rules
                [x] normal move
                [x] capturing
            [] king rules
                [x] normal move
                [x] capturing
            [] queen rules
                [x] normal move
                [x] capturing

        
debugging:  

    BUG in Piece and Board:

    Piece: when changing how legal_spaces is updated
        legal_spaces = get_legal_spaces  instad of legal_spaces.append(get_legal_spaces)
    then game crashes with error from
    Board's calculate boardsquare
    ( i think i fixed it by making sure get_legal_spaces returns an array)

    [solved] BUG:
        pieces can move off board. (there are legal spaces outside the board B9, etc)

    [solve] Bug: knight moves off board when at Square A1. SOLVED: ranges are [,)

    [solved]-> Bug: white king can castle on blacks side lol
    [solved]-> bug: white queenside castling triggers black not being allowed to castle anymore


    [solved] Bug: rook doesnt work??? Bishops dont work???
        SOLUTION: Since the pieces only understand occupied squares after
        a call to update_spaces_dictionary,  Calling update_spaces_dictionary in loadFEN() resolves it. 
    
    [solved] HARD Bug; Sometimes the game will crash when moveing pieces
        -> sometimes happens after capturing alot
        -> when it happens, it usually is a problem calling "piece.parity (on NULL instance)"
            -> while calling Rook Legality
            -> happend in bishop too (same block of code though)
                -> bug happens after:
                    white queen kill black pawn on e4
                    black queen kill white pawn on d4
                    click   black knight on C6
                            white queen on d5
                            white knight on f3
                                moving another piece fixes it
                    
                    black queen kills white pawn on d4
                    then click  white knight on f3
                                black knight on c6
                    
                    PRETTY SURE: happens after:
                        clicked piece COULD move to a space where a capture has JUST occured
                        it seems, the call is_occupied() is returning a Deleted Object 

        
        BUG FIX: piece calls free() instead of queue_free() upon capture

    [solved] BUG:   1...    H6 H5,
                    2.BH6   G7 G5, (triggers enpassant target)
                    3.G2 G3 G5 G4, crashes

            BUG: getting stack overflow sometimes