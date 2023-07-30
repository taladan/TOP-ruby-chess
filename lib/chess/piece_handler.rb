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
  def move_piece(from_square, to_square, player, override: false)
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

    put_piece(from_square, to_square, player)
    nil
  end

  private

  # Calculate squares piece can move to.  Accepts two, n-element arrays, returns one n-element array
  def add_current_and_possible_squares(current, possible)
    [current, possible].transpose.map { |x| x.reduce(:+) }
  end

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

  # Takes an array of squares and gets their 2d array positions
  def get_square_positions(array_of_squares)
    output = []
    array_of_squares.each { |square| output << square.position }
    output
  end

  def put_piece(from_square, to_square, player)
    # load squares
    from = find_square_by_name(from_square)
    to = find_square_by_name(to_square)

    # load piece
    piece = from.contents

    # raise OpponentsPieceChosenError unless piece.color == player.color
    raise EmptySquareError if from.contents.nil?

    raise PathError unless path_clear?(from, to)

    swap_contents(from, to, piece) unless validate_position(to.position, piece.color).nil?
  end

  # return true if no pieces in path, false if pieces in path
  #
  # for path finding, I am using compass directionals to track desired piece movement
  # I.E. nw, n, ne, e, se, s, sw, w
  # With the direction, we are able to traverse the neighboring squares
  # in the direction of movement and test for the presence of a piece within the path of the moving piece.
  def path_clear?(from, to)
    direction = determine_direction(from, to)
    path = get_path(from, to, direction)
    output = true
    path.each do |square|
      output = false if square.occupied?
    end
    output
  end

  # return the symbol representative of the direction the piece is moving
  #
  # determining direction is simple enough by using array math to test for an increase or decrease
  # in value of either the row indicator or the column indicator for a particular square
  def determine_direction(from, to)
    row = from.x <=> to.x
    col = from.y <=> to.y

    case [row, col]
    # column from gt column to
    when [0, 1]
      :s
    # row from gt row to
    when [1, 0]
      :w
    # row from gt row to && col from gt col to
    when [1, 1]
      :sw
    # row from lt row to
    when [-1, 0]
      :e
    # row from lt row to && col from lt col to
    when [-1, -1]
      :ne
    # row from gt row to && col from lt col to
    when [1, -1]
      :nw
    # row from lt row to && col from gt col to
    when [-1, 1]
      :se
    # col from lt col to
    when [0, -1]
      :n
    end
  end

  # recursively get array of squares that form path between from square and to square
  def get_path(from, to, direction, current_position = from.position, output = [])
    square = find_square_by_position(current_position)
    output << square unless current_position == from.position
    return output if current_position == to.position

    next_position = find_square_by_name(square.neighbors[direction]).position
    get_path(from, to, direction, next_position, output)
  end

  # Validate 2d array position either empty, occupied by teammate, occupied by enemy
  # Return target square if on board and empty or on board and contains enemy piece
  def validate_position(square, color)
    # Move invalid if square not on board
    raise InvalidTargetPositionError unless on_board?(square)

    target_square = find_square_by_position(square) if square.is_a?(Array)
    target_square = square if square.is_a?(Square)

    # occupied by teammate
    raise InvalidTargetPositionError if target_square.occupied? && target_square.contents.color == color

    # Empty square
    return target_square unless target_square.occupied?

    # occupied by enemy
    return target_square if target_square.occupied? && target_square.contents.color != color
  end

  # swap squares contents
  def swap_contents(from, to, piece)
    to.contents = from.contents
    from.contents = nil
    piece.current_square = to
  end
end
