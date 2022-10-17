# godot chess engine
 working on this to keep me busy

got the pieces to be the right size
got all the pieces to the correct "Squares"
fixed `boardRect` so it updates correctly now
all pieces have correct texutres

pieces now take up entire square
centered the pieces on their respective squares
board sits at an imprecise (although correct) distance from the corner of the window

refactored "Update piece" into its own node

refactored a ton:
    moved alot of "piece" methods into its own piece class with its own script

debugging:  

TODO: 
    
    I realized i have been essentially creating classes dynamically. 
    Instead, I should write one class and instance it multiple times
    I.E. make a "Piece" class, and instance it multiple times 


    make pieces draggable
    make board stay where it is relative to the window size
    
