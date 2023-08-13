# king.rb
# frozen_string_literal: true

require "chess_piece"

module Pieces
  # King chess piece
  class King < ChessPiece
    attr_reader :icon

    def initialize(piece, color, square)
      @icon = "♚"
      super(piece, color, square)
    end

    # King can move any single square in a straight line from current square unless castling
    # king piece possible moves
    def self.possible_moves
      moves = [
        [1, 1],
        [-1, -1],
        [-1, 1],
        [1, -1],
        [0, 1],
        [0, -1],
        [1, 0],
        [-1, 0]
      ]
      castle_moves = [[0, 2], [0, -2]]

      return moves += castle_moves unless @has_moved

      moves
    end
  end
end
