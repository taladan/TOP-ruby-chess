# chess_piece.rb
# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength

# Parent class for all chess pieces
module Pieces
  class ChessPiece
    attr_accessor :current_square
    attr_reader :name, :color, :possible_moves

    def initialize(name, color, current_square)
      raise ArgumentError, "Invalid Name" unless %w[K Q B N R P k q b n r p].include?(name)

      @color = color
      @name = name.upcase
      @current_square = current_square
      @possible_moves = piece_moves
      colorize_name
    end

    private

    # Apply color to piece
    def colorize_name
      @name = @name.red if @color == "white"
      @name = @name.blue if @color == "black"
    end

    # Apply correct possible moves
    def piece_moves
      case @name
      when "K"
        @possible_moves = King::POSSIBLE_MOVES
      when "Q"
        @possible_moves = Queen::POSSIBLE_MOVES
      when "B"
        @possible_moves = Bishop::POSSIBLE_MOVES
      when "N"
        @possible_moves = Knight::POSSIBLE_MOVES
      when "R"
        @possible_moves = Rook::POSSIBLE_MOVES
      when "P"
        @possible_moves = Pawn::POSSIBLE_MOVES
      end
    end
  end
end
# rubocop:enable Metrics/MethodLength
