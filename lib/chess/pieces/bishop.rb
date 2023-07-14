# bishop.rb
# frozen_string_literal: true

require "chess_piece"

# Bishop chess piece
module Pieces
  class Bishop < ChessPiece
    attr_reader :icon

    POSSIBLE_MOVES = [
      [1, 1],
      [2, 2],
      [3, 3],
      [4, 4],
      [5, 5],
      [6, 6],
      [7, 7],
      [8, 8],
      [1, -1],
      [2, -2],
      [3, -3],
      [4, -4],
      [5, -5],
      [6, -6],
      [7, -7],
      [8, -8],
      [-1, 1],
      [-2, 2],
      [-3, 3],
      [-4, 4],
      [-5, 5],
      [-6, 6],
      [-7, 7],
      [-8, 8],
      [-1, -1],
      [-2, -2],
      [-3, -3],
      [-4, -4],
      [-5, -5],
      [-6, -6],
      [-7, -7],
      [-8, -8]
    ]

    def initialize(piece, color, square)
      @icon = "♝"
      super(piece, color, square)
    end
  end
end
