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

  # TODO: This may be unusable...leaving it for now.
  # return an array of all possible opponent's pieces
  def self.all_possible_opponents(color)
    output = []
    ObjectSpace.each_object(ChessPiece).each { |piece| output << piece unless piece.color == color }
    output
  end
  
  # this returns an array of pieces that threaten the queried square
  def self.calculate_opponent_threats(square)
    opponent_pieces = PieceHandler.all_possible_opponents(square.contents.color)
    threat_array = []
    opponent_pieces.each do |piece|
      # TODO: For some reason calculate_possible_moves is erroring here.  Not sure why yet
      require "pry-byebug"
      binding.pry
      piece_moves = calculate_possible_moves(piece.current_square.name)
      threat_array << piece if piece_moves.include?(square)
    end
    threat_array
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

  # This loads the data for knowing what is moving where
  # It takes two string values (from_square, to_square) and a player object
  # returns target/to square
  def put_piece(from_square, to_square, player)
    # load squares
    from = find_square_by_name(from_square)
    to = find_square_by_name(to_square)

    # load piece
    piece = from.contents

    # raise OpponentsPieceChosenError unless piece.color == player.color
    raise EmptySquareError if from.contents.nil?

    # Check for pieces in the way of movement
    raise PathError unless path_clear?(from, to, player)

    swap_contents(from, to, piece) unless validate_position(to.position, piece.color).nil?
  end

  # return true if no pieces in path, false if pieces in path
  #
  # for path finding, I am using compass directionals to track desired piece movement
  # i.e. nw, n, ne, e, se, s, sw, w
  # with the direction, we are able to traverse the neighboring squares
  # in the direction of movement and test for the presence of a piece within the path of the moving piece
  # pawns, knights, and kings have special rules for movements
  def path_clear?(from, to, player)
    direction = determine_direction(from, to)
    piece = from.contents
    path = get_path(from, to, direction) unless piece.is_a?(Knight)

    # pawns can only move n (if white), s (if black) and only attack ne/nw (if white), se/sw (if black)
    if piece.is_a?(Pieces::Pawn)
      pawn_check(piece, direction, path)

    # Ensure target square is opponent's piece when occupied
    elsif piece.instance_of?(Pieces::Knight)
      knight_check(piece, to)

    # Possible use for castling
    elsif piece.instance_of?(Pieces::King)
      # check for length of path if path == 3, MUST be castle
      castle_check unless piece.has_moved && %i[e w].include?(direction) && path == 3

      # otherwise normal king check
      king_check(piece, path, direction)

    # Queen, Bishop, Rook
    else
      piece_check(player, path)
    end
  end

  # rules for pawn movement
  def pawn_check(piece, direction, path)
    # white pawns can move: n, ne, nw
    # black pawns can move: s, se, sw
    raise IllegalMoveError unless piece.can_move_direction?(direction)

    if %i[n s].include?(direction)
      pawn_movement(piece, path)
    # attack only one space
    elsif %i[ne se nw sw].include?(direction)
      pawn_attack(piece, path)
    else
      raise InvalidTargetPositionError
    end
  end

  # pawn moves: can move 1 or 2 if pawn hasn't moved already, can't move if target square is occupied
  def pawn_movement(piece, path)
    # if the pawn hasn't moved, it can move 1 or 2 spaces otherwise only 1 space at a time
    raise IllegalMoveError if path.drop(1).count > piece.move_limit(:move)

    # can't attack in a straight line
    return false if path.last.occupied?

    piece.has_moved = true unless piece.has_moved

    true
  end

  # pawn attacks: can only move one space, target square MUST have opponent's piece in it
  def pawn_attack(piece, path)
    raise IllegalMoveError if path.drop(1).count > piece.move_limit(:attack)

    target = path.last

    # can only be attacking, target must have opponent's piece in it
    return false unless target.occupied? && target.contents.color != piece.color

    true
  end

  # check if pawns are in a state that triggers en passant (https://www.chess.com/article/view/how-to-capture-en-passant)
  # this checks to see if the conditions for an en passant offer should be made to the opponent of the moving player
  def en_passant?(piece, path)
    # must have been triggered by double move
    path.count == 3 && path.last.position[0] == piece.en_passant_rank && path.last.en_passant_neighbors?
  end

  # en passant goes here
  def en_passant
    # offer opponent a chance for en passant 
    # if yes, that becomes opponent's movement and play goes back to
    # the player whose movement initiated the en passant
  end

  # rules for knight movement
  def knight_check(piece, target)
    return false if target.occupied? && target.contents.color == piece.color

    true
  end

  # rules for king movement
  def king_check(piece, path)
    target = path.last
    # king CANNOT move into a threatened square
    raise MoveIntoCheckError if target.threatened?(piece)

    return false if target.occupied? && target.contents.color == piece.color

    true
  end

  # castling checks go here
  def castle_check
    true
  end

  # rules for all other movement
  def piece_check(player, path)
    output = true
    path.each do |square|
      # We don't test the square we're starting from
      next if square == path.first

      if square == path.last
        # allow player to take piece if square is occupied by opponent's piece
        output = true if square.occupied? && square.contents.color != player.color
      else
        # All squares between `from` and `to` non-inclusive must be empty
        output = false if square.occupied?
      end
    end
    output
  end

  # Old path clear function - to be removed
  def old_path_clear?(from, to, player)
    output = true
    direction = determine_direction(from, to)
    piece = from.contents
    path = get_path(from, to, direction) unless piece.is_a?(Knight)
    path.each do |square|
      # We don't test the square we're starting from
      next if square == path.first

      if square == path.last
        # allow player to take piece if square is occupied by opponent's piece
        output = true if square.occupied? && square.contents.color != player.color
      else
        # All squares between `from` and `to` non-inclusive must be empty
        output = false if square.occupied?
      end
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
    output << square
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
  # returns value of target square the piece moved to
  def swap_contents(from, to, piece)
    to.contents = from.contents
    from.contents = nil
    piece.current_square = to
  end
end
