# piece_handler.rb
# frozen_string_literal: true

# Module file containing piece logic
# Handle piece logic
module PieceHandler
  require "chess_piece"
  require "piece_maker"
  require "king"
  require "queen"
  require "bishop"
  require "knight"
  require "rook"
  require "pawn"
  require "errors"
  require "square_handler"

  include Pieces
  include ChessErrors

  # Using [FEN](https://www.chess.com/terms/fen-chess) standard for 
  # piece 'naming' to use a single letter indication for piece names
  #
  # Uppercase - White pieces
  # Lowercase - Black pieces

  # Syntax: #add_piece(piece, position)
  #
  # Piece must be in @valid_piece_names format
  # Position on board must exist and be empty
  def add_piece(piece, position)
    raise InvalidTargetPositionError unless @valid_square_names.include?(position.downcase)
    raise InvalidPieceNameError unless @valid_piece_names.include?(piece)

    color = "white" if /[[:upper:]]/.match(piece)
    color = "black" if /[[:lower:]]/.match(piece)

    square = retrieve_square(position.downcase)
    chesspiece = PieceMaker.make_piece(piece, color, square)
    # Refactor to use actual piece creation instead of instantiating ChessPiece
    square.contents = chesspiece
    chesspiece
  end

  # Return an array of valid and open squares to move to
  def calculate_possible_moves(from_square)
    possible_moves = []
    # load piece
    piece = retrieve_square(from_square).contents

    # read current position from piece
    current = piece&.current_square&.position

    # loop through possible moves and build array
    piece.possible_moves.each do |move|
      square = validate_position(add_current_and_possible_squares(current, move), piece.color)
      possible_moves << square
    rescue InvalidTargetPositionError
      next
    end
    possible_moves.compact
  end

  # move a piece from a named square to a named square ('a1-h8')
  def move_piece(from_square, to_square, player, override: false)
    raise InvalidStartingPositionError unless @valid_square_names.include?(from_square)
    raise InvalidTargetPositionError unless @valid_square_names.include?(to_square)

    # If override is false, we stick with the piece's movement patterns.
    # If override is true, we ignore piece's movement patterns and just
    # place piece where we desire.
    if override == false
      valid_moves = get_square_positions(calculate_possible_moves(from_square))
      target = retrieve_square(to_square)
      raise IllegalMoveError unless valid_moves.include?(target.position)
    end

    put_piece(from_square, to_square, player)
    nil
  end

  # TODO: This may be unusable...leaving it for now.
  # return an array of all possible opponent's pieces
  def self.all_possible_opponents(color)
    output = []
    # TODO: Objectspace is used mainly for debugging and can cause weird issues.  We need to track a 
    # List of pieces that exist within the framework of the game - might need to live on board.
    @pieces.each { |piece| output << piece unless piece.color == color }
    output
  end

  private

  # create a new piece object named `piece` of `color` on `square`
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
end
