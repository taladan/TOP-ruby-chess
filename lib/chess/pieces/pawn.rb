# pawn.rb
# frozen_string_literal: true

require "chess_piece"

module Pieces
  # Pawn chess piece
  class Pawn < ChessPiece
    attr_reader :icon

    def initialize(piece, color, square)
      @icon = "♟"
      @has_moved = false
      super(piece, color, square)
      @possible_moves = possibles
    end

    # Pawn can move 2 squares forward in first move or 1 square forward first move, 
    # subsequent moves are 1 square forward.  May only attack on a forward diagonal.  
    # Can't move backwards at all.
    # Range of posslble movements
    def possibles
      # hasn't moved, white
      return [[0, 1], [0, 2], [1, 1], [-1, 1]] if @color == "white" && @has_moved == false
      # hasn't moved, black
      return [[0, -1], [0, -2], [1, -1], [-1, -1]] if @color == "black" && @has_moved == false
      # has moved, white
      return [[0, 1], [1, 1], [-1, 1]] if @color == "white" && @has_moved
      # has moved, black
      return [[0, -1], [1, -1], [-1, -1]] if @color == "black" && @has_moved
    end
  end
end
