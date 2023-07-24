# bishop.rb
# frozen_string_literal: true

require "chess_piece"

module Pieces
  # Bishop chess piece
  class Bishop < ChessPiece
    attr_reader :icon

    def initialize(piece, color, square)
      @icon = "♝"
      super(piece, color, square)
    end

    # Range of all possible bishop moves
    def self.possible_moves
      [
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
    end
  end
end
