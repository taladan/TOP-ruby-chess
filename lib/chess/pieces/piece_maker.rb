# piece_maker.rb
# frozen_string_literal: true

module Pieces
  class PieceMaker
    require "king"
    require "queen"
    require "bishop"
    require "knight"
    require "rook"
    require "pawn"

    def self.make_piece(piece, color, square)
      case piece.upcase
      when "K"
        Pieces::King.new(piece, color, square)
      when "Q"
        Pieces::Queen.new(piece, color, square)
      when "B"
        Pieces::Bishop.new(piece, color, square)
      when "N"
        Pieces::Knight.new(piece, color, square)
      when "R"
        Pieces::Rook.new(piece, color, square)
      when "P"
        Pieces::Pawn.new(piece, color, square)
      else
        raise InvalidPieceError
      end
    end
  end
end
