# knight.rb
# frozen_string_literal: true

require "chess_piece"

module Pieces
  # Knight chess piece
  class Knight < ChessPiece
    attr_reader :icon

    def initialize(piece, color, square)
      @icon = "♞"
      super(piece, color, square)
    end

    # Knight can move any combination of 2,1 squares
    def self.possible_moves
      [
        [1, 2],
        [-1, 2],
        [1, -2],
        [-1, -2],
        [2, 1],
        [-2, 1],
        [2, -1],
        [-2, -1]
      ]
    end
  end
end
