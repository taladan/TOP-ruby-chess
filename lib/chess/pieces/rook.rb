# rook.rb
# frozen_string_literal: true

require "chess_piece"

module Pieces
  # Rook chess piece
  class Rook < ChessPiece
    attr_reader :icon


    def initialize(piece, color, square)
      @icon = "♜"
      super(piece, color, square)
      # Rook can move any number of squares in a straight line, left/right/up/down, no diagonals
    end

    # Range of all possible rook moves
    def self.possible_moves
      [
        [0, 1],
        [0, 2],
        [0, 3],
        [0, 4],
        [0, 5],
        [0, 6],
        [0, 7],
        [0, 8],
        [0, -1],
        [0, -2],
        [0, -3],
        [0, -4],
        [0, -5],
        [0, -6],
        [0, -7],
        [0, -8],
        [1, 0],
        [2, 0],
        [3, 0],
        [4, 0],
        [5, 0],
        [6, 0],
        [7, 0],
        [8, 0],
        [-1, 0],
        [-2, 0],
        [-3, 0],
        [-4, 0],
        [-5, 0],
        [-6, 0],
        [-7, 0],
        [-8, 0]
      ]
    end
  end
end