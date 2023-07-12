# rook.rb
# frozen_string_literal: true

require "chess_piece"

# Rook chess piece
module Pieces
  class Rook < ChessPiece
    attr_reader :icon

    POSSIBLE_MOVES = [
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

    def initialize
      @icon = "♜"
      super
      # Rook can move any number of squares in a straight line, left/right/up/down, no diagonals
    end
  end
end