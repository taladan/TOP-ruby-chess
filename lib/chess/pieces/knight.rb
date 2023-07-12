# knight.rb
# frozen_string_literal: true

require "chess_piece"

# Knight chess piece
module Pieces
  class Knight < ChessPiece
    attr_reader :icon

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

    def initialize
      @icon = "♞"
      super
      # Knight can move any combination of 2,1 squares
    end
  end
end
