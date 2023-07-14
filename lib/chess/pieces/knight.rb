# knight.rb
# frozen_string_literal: true

require "chess_piece"

# Knight chess piece
module Pieces
  class Knight < ChessPiece
    attr_reader :icon

    # Knight can move any combination of 2,1 squares
    POSSIBLE_MOVES = [
      [1, 2],
      [-1, 2],
      [1, -2],
      [-1, -2],
      [2, 1],
      [-2, 1],
      [2, -1],
      [-2, -1]
    ]

    def initialize(piece, color, square)
      @icon = "♞"
      super(piece, color, square)
    end
  end
end
