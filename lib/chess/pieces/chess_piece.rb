# chess_piece.rb
# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength

# Parent class for all chess pieces
module Pieces
  # ChessPiece object
  # When creating a new chess piece, it must follow FEN chess notation:
  #
  # K = White King
  # Q = White Queen
  # B = White Bishop
  # N = White Knight
  # R = White Rook
  # P = White Pawn
  # k = Black King
  # q = Black Queen
  # b = Black Bishop
  # n = Black Knight
  # r = Black Rook
  # p = Black Pawn
  #
  # If an invalid piece name is passed when instantiating a chess piece, it will
  # throw an `InvalidPieceNameError`.
  class ChessPiece
    attr_accessor :current_square, :has_moved
    attr_reader :name, :color, :possible_moves, :icon

    def initialize(name, color, current_square)
      require "colorize"
      raise InvalidPieceNameError unless %w[K Q B N R P k q b n r p].include?(name)

      @color = color
      @name = name.upcase
      @current_square = current_square
      @has_moved = false
      @possible_moves = piece_moves(color)
      colorize_icon
    end

    def can_move?(player)
      player.color == @color
    end

    private

    # Apply color to piece
    def colorize_icon
      @icon = @icon.red if @color == "white"
      @icon = @icon.blue if @color == "black"
    end

    # Apply correct possible moves
    def piece_moves(color)
      case @name
      when "K"
        @possible_moves = King.possible_moves
      when "Q"
        @possible_moves = Queen.possible_moves
      when "B"
        @possible_moves = Bishop.possible_moves
      when "N"
        @possible_moves = Knight.possible_moves
      when "R"
        @possible_moves = Rook.possible_moves
      when "P"
        # @possible_moves = Pawn.possible_moves
      end
    end
  end
end
# rubocop:enable Metrics/MethodLength
