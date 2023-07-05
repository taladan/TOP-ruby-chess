# pawn.rb
require_relative 'chess_piece'

# Pawn chess piece
module Pawn
  class Pawn < ChessPiece
    # Pawn can move 2 squares forward in first move or 1 square forward first move, subsequent moves are 1 square forward.  May only attack on
    # a forward diagonal.  Can't move backwards at all.
    HAS_MOVED = false
    
    if HAS_MOVED == false
      POSSIBLE_MOVES = [
        [0,1]
        [0,2]
        [1,1]
        [-1,1]
      ]
    else
      POSSIBLE_MOVES = [
        [0,1]
        [1,1]
        [-1,1]
      ]
  end
end
