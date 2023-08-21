# square_handler.rb
# frozen_string_literal: true

# This module contains the logic needed to deal with identification and
# manipulation of nodes (called squares) of a chess board.
module SquareHandler
  require "square"
  require "errors"
  include ChessErrors
  # count total number of squares in board
  # takes nothing, returns integer
  # This method is currently unreferenced anywhere
  def count
    @squares.length
  end

  def retrieve_square(square)
    return find_square_by_name(square) if square.is_a?(String)
    return find_square_by_position(square) if square.is_a?(Array)
    return square if square.is_a?(Square)
  end

  # this will give squares positional information as an easier way to reference as a 2d array as well as name info
  # allows for some math operations like assign_neighbors
  def assign_square_positions(arr2d)
    @squares.each_with_index do |square, index|
      square.assign_positions(arr2d[index])
    end
    nil
  end

  # return array of all squares currently containing an opposing piece
  def self.all_opponent_squares(color)
    output = []
    @squares.each do |square|
      next unless square.occupied?

      output << square unless square.contents.color == color
    end
    output
  end

  # - Square can only be targted by other positions if:
  #   - Any other square's contents has square.position in its list of possible moves
  #   - if the above is true, those contents (piece) color must be opposite of square's content's color
  def self.threatened?(square)
    # - Must be occupied
    return false unless square.occupied?

    assess_threats(square)

    return true if square.threatened

    false
  end

  # sets threats for square
  def self.assess_threats(square)
    square.threats = PieceHandler.calculate_opponent_threats(square)

    square.threatened == true unless square.threats.nil?
  end

  # Validate 2d array position either empty, occupied by teammate, occupied by enemy
  # Return target square if on board and empty or on board and contains enemy piece
  def validate_position(square, color)
    target_square = retrieve_square(square)
    # Move invalid if square not on board
    raise InvalidTargetPositionError if target_square.nil?
    raise InvalidTargetPositionError unless on_board?(target_square.position)

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

  # Takes an array of squares and gets their 2d array positions
  def get_square_positions(array_of_squares)
    output = []
    array_of_squares.each { |square| output << square.position }
    output
  end

  # This loads the data for knowing what is moving where
  # It takes two string values (from_square, to_square) and a player object
  # returns target/to square
  # FIXME: rename this
  def put_piece(from_square, to_square, player)
    # load squares
    from = retrieve_square(from_square)
    to = retrieve_square(to_square)

    # load piece
    piece = from.contents

    # raise OpponentsPieceChosenError unless piece.color == player.color
    raise EmptySquareError if from.contents.nil?
    path = PieceHandler::Path.new(@board)
    # Check for pieces in the way of movement
    raise PathError unless path.clear?(from, to, player)

    swap_contents(from, to, piece) unless validate_position(to.position, piece.color).nil?
  end

  # this returns an array of pieces that threaten the queried square
  def self.calculate_opponent_threats(square)
    opponent_pieces = PieceHandler.all_possible_opponents(square.contents.color)
    threat_array = []
    opponent_pieces.each do |piece|
      # TODO: For some reason calculate_possible_moves is erroring here.  Not sure why yet
      piece_moves = calculate_possible_moves(piece.current_square)
      threat_array << piece if piece_moves.include?(square)
    end
    threat_array
  end

  private

  # takes a string (ex: `a1`)
  # returns `Square` object
  def find_square_by_name(name)
    @squares.each do |square|
      return square if square.name == name
    end
    nil
  end

  # takes an array (ex: [a1])
  # returns 'Square' object
  def find_square_by_position(position)
    @squares.each do |square|
      return square if square.position == position
    end
    nil
  end

  # Calculate squares piece can move to.  Accepts two, n-element arrays, returns one n-element array
  def add_current_and_possible_squares(current, possible)
    [current, possible].transpose.map { |x| x.reduce(:+) }
  end

  # This is a little raw.  If I were to refactor this, I'd set up a setter/getter function for neighbors in square.
  # This sets an unweighted, undirected edge between square and its `key` neighbor
  def add_edge(square, neighbor, key)
    opposites = { n: "s", ne: "sw", e: "w", se: "nw", s: "n", sw: "ne", w: "e", nw: "se" }
    square.neighbors[key] = neighbor.name
    neighbor.neighbors[opposites[key].to_sym] = square.name
    nil
  end

  # assign each neighboring square's name to square, or nil if the calculated position if off board
  def assign_neighbors(square)
    { n: [0, 1], ne: [1, 1], e: [1, 0], se: [1, -1], s: [0, -1], sw: [-1, -1], w: [-1, 0],
      nw: [-1, 1] }.each do |k, v|
      calculated_position = [square.position[0] + v[0], square.position[1] + v[1]]
      if on_board?(calculated_position)
        neighbor = retrieve_square(calculated_position)
        add_edge(square, neighbor, k)
      else
        square.neighbors[k] = nil
      end
    end
  end

  # determines which way the board should be rotated and 
  # builds individual rows of squares for correct display
  def build_row(rotate, row, column = 0, output = [])
    if rotate
      build_row_black_on_bottom(row, column, output)
    else
      build_row_white_on_bottom(row, column, output)
    end
    # output
  end

  # recursively build a row of squares for display
  # black player's move
  def build_row_black_on_bottom(row, column, output)
    square = retrieve_square([column, row])
    # square.threatened = square.threatened?
    return output << square if square.neighbors[:w].nil?

    output << square
    build_row_black_on_bottom(row, column - 1, output)
  end

  # recursively build a row of squares for display
  # white player's move
  def build_row_white_on_bottom(row, column, output)
    square = retrieve_square([column, row])
    # square.threatened = square.threatened?
    return output << square if square.neighbors[:e].nil?

    output << square
    build_row_white_on_bottom(row, column + 1, output)
  end
end
