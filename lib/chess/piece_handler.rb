# piece_handling.rb
# frozen_string_literal: true

# Module file containing piece logic
require "chess_piece"
require "king"
require "queen"
require "bishop"
require "knight"
require "rook"
require "pawn"
require "errors"

# Handle piece logic
module PieceHandler
  include Pieces
  include ChessErrors
  # Using [FEN](https://www.chess.com/terms/fen-chess) standard for piece 'naming' to use a single letter indication for piece names
  #
  # Uppercase - White pieces
  # Lowercase - Black pieces
  @@valid_piece_names = %w[K Q B N R P k q b n r p]

  # Syntax: #add_piece(piece, position)
  #
  # Piece must be in @@valid_piece_names format
  # Position on board must exist and be empty
  def add_piece(piece, position)
    raise InvalidTargetPositionError unless @valid_squares.include?(position.downcase)
    raise InvalidPieceNameError unless @@valid_piece_names.include?(piece)

    color = "white" if /[[:upper:]]/.match(piece)
    color = "black" if /[[:lower:]]/.match(piece)

    square = find_square_by_name(position.downcase)
    square.contents = ChessPiece.new(piece, color, square)
    nil
  end

  # Return an array of valid and open squares to move to
  def calculate_possible_moves(from_square)
    possible_moves = []
    # load piece
    piece = find_square_by_name(from_square).contents
    # read current position from piece
    current = piece&.current_square&.position

    # loop through possible moves and build array
    piece&.possible_moves&.each do |move|
      possible_moves << validate_position(add_current_and_possible_squares(current, move), piece.color)
    end
    possible_moves&.compact
  end

  # move a piece from a named square to a named square ('a1-h8')
  def move_piece(from_square, to_square, override: false)
    raise InvalidStartingPositionError unless @valid_squares.include?(from_square)
    raise InvalidTargetPositionError unless @valid_squares.include?(to_square)

    # If override is false, we stick with the piece's movement patterns.
    # If override is true, we ignore piece's movement patterns and just
    # place piece where we desire.
    if override == false
      valid_moves = get_square_positions(calculate_possible_moves(from_square))
      target = find_square_by_name(to_square)
      raise IllegalMoveError unless valid_moves.include?(target.position)
    end

    put_piece(from_square, to_square)
    nil
  end

  private

  # Calculate squares piece can move to.  Accepts two, n-element arrays, returns one n-element array
  def add_current_and_possible_squares(current, possible)
    [current, possible].transpose.map { |x| x.reduce(:+) }
  end

  # Takes an array of squares and gets their 2d array positions
  def get_square_positions(array_of_squares)
    output = []
    array_of_squares.each { |square| output << square.position }
    output
  end

  def put_piece(from_square, to_square)
    # load squares
    from = find_square_by_name(from_square)
    to = find_square_by_name(to_square)

    # load piece
    piece = from.contents

    raise EmptySquareError if from.contents.nil?

    # swap squares contents
    to.contents = from.contents
    from.contents = nil
    piece.current_square = to
  end

  # Validate 2d array position either empty, occupied by teammate, occupied by enemy
  # Return nil if off board or occupied by team mate (invalid position to move to)
  # Return target square if on board and empty or on board and contains enemy piece
  def validate_position(target_position, color)
    return nil unless on_board?(target_position)

    target_square = find_square_by_position(target_position)
    # Empty square
    return target_square unless target_square.occupied?

    # occupied by enemy
    return target_square if target_square.occupied? && target_square.contents.color != color

    # occupied by teammate
    return nil if target_square.occupied? && target_square.contents.color == color
  end
end
