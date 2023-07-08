# king.rb
# frozen_string_literal: true

require "chess_piece"

# King chess piece
module Pieces
  class King < ChessPiece
    # King can move any single square in a straight line from current square
    POSSIBLE_MOVES = [
      [1, 1],
      [-1, -1],
      [-1, 1],
      [1, -1],
      [0, 1],
      [0, -1],
      [1, 0],
      [-1, 0]
    ]
  end
end