# piece_handler.rb
# frozen_string_literal: true

# Module file containing piece logic
require "chess_piece"
require "piece_maker"
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
    chesspiece = PieceMaker.make_piece(piece, color, square)
    # Refactor to use actual piece creation instead of instantiating ChessPiece
    square.contents = chesspiece
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
    piece.possible_moves.each do |move|
      begin
        possible_moves << validate_position(add_current_and_possible_squares(current, move), piece.color)
      rescue InvalidTargetPositionError
        next
      end
    end
    possible_moves.compact
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

  def create_piece(piece, color, square)
    case piece
    when "K"
      King.new(piece, color, square)
    when "Q"
      Queen.new(piece, color, square)
    when "B"
      Bishop.new(piece, color, square)
    when "N"
      Knight.new(piece, color, square)
    when "R"
      Rook.new(piece, color, square)
    when "P"
      Pawn.new(piece, color, square)
    end
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

    swap_contents(from, to, piece) unless validate_position(to.position, piece.color).nil?
  end

  # Validate 2d array position either empty, occupied by teammate, occupied by enemy
  # Return nil if off board or occupied by team mate (invalid position to move to)
  # Return target square if on board and empty or on board and contains enemy piece
  def validate_position(square, color)

    # Move invalid if square not on board
    raise InvalidTargetPositionError unless on_board?(square)

    target_square = find_square_by_position(square) if square.is_a?(Array)
    target_square = square if square.is_a?(Square)

    # Empty square
    return target_square unless target_square.occupied?

    # occupied by enemy
    return target_square if target_square.occupied? && target_square.contents.color != color

    # occupied by teammate
    return nil if target_square.occupied? && target_square.contents.color == color
  end

  private

  # swap squares contents
  def swap_contents(from, to, piece)
    to.contents = from.contents
    from.contents = nil
    piece.current_square = to
  end
end
