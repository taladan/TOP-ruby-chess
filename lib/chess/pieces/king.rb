# king.rb
# frozen_string_literal: true

require "chess_piece"

module Pieces
  # King chess piece
  class King < ChessPiece
    attr_reader :icon

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

    def initialize(piece, color, square)
      @icon = "♚"
      # King can move any single square in a straight line from current square
      super(piece, color, square)
    end
  end
end