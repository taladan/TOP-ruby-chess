# king.rb
# frozen_string_literal: true

require "chess_piece"

module Pieces
  # King chess piece
  class King < ChessPiece
    attr_reader :icon
    attr_accessor :has_moved

    def initialize(piece, color, square)
      @icon = "♚"
      @has_moved = nil
      @possible_moves = possibles
      super(piece, color, square)
    end

    # King can move any single square in a straight line from current square unless castling
    # king piece possible moves
    def possibles
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

      moves += castle_moves unless @has_moved

      moves
    end
  end
end
