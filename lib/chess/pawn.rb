# pawn.rb
require_relative 'chess_piece'

# Pawn chess piece
module Pawn
  # Pawn can move 2 squares forward in first move or 1 square forward first move, subsequent moves are 1 square forward.  May only attack on
  # a forward diagonal.  Can't move backwards at all.
  FIRST_MOVE = true
  POSSIBLE_MOVES = nil
end
