# pawn.rb
# frozen_string_literal: true

require "chess_piece"

# Pawn chess piece
module Pieces
  class Pawn < ChessPiece
    attr_reader :icon
    POSSIBLE_MOVES = [
      [0, 1],
      [0, 2],
      [1, 1],
      [-1, 1],
      [0, 1],
      [1, 1],
      [-1, 1]
    ]

    def initialize(piece, color, square)
      @icon = "♟"
      # Pawn can move 2 squares forward in first move or 1 square forward first move, subsequent moves are 1 square forward.  May only attack on
      # a forward diagonal.  Can't move backwards at all.
      @has_moved = false
      super(piece, color, square)
    end
  end
end
