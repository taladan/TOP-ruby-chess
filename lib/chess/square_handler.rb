# square_handler.rb
# frozen_string_literal: true

# This module contains the logic needed to deal with identification and
# manipulation of nodes (called squares) of a chess board.
module SquareHandler
  require "square"
  # count total number of squares in board
  # takes nothing, returns integer
  def count
    @squares.length
  end

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

  # Takes an array of two values: `[col, row]`
  # returns string
  def get_name_by_position(position)
    return nil if position.nil?

    square = find_square_by_position(position)
    square.name
  end

  # Get a square's position from its name
  #
  # requires a non-nil value to be passed
  # returns string
  def get_position_by_name(name)
    return nil if name.nil?

    square = find_square_by_name(name)
    square.position
  end

  # this will give squares positional information as an easier way to reference as a 2d array as well as name info
  # allows for some math operations like assign_neighbors
  def assign_square_positions(arr2d)
    @squares.each_with_index do |square, index|
      square.assign_positions(arr2d[index])
    end
    nil
  end

  def threatened?(square)
    output = false
    square.neighbors.each do |neighbor|
      next unless square.occupied?

      next if neighbor[1].nil?

      neighboring_square = find_square_by_name(neighbor[1])
      next unless neighboring_square.occupied?

      output = true if neighboring_square.contents.color != square.contents.color
    end
    output
  end

  # return array of all squares currently containing an opposing piece
  def self.all_opponent_squares(color)
    output = []
    ObjectSpace.each_object(Square) do |square|
      next unless square.occupied?

      output << square unless square.contents.color == color
    end
    output
  end

  private

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
        neighbor = find_square_by_position(calculated_position)
        add_edge(square, neighbor, k)
      else
        square.neighbors[k] = nil
      end
    end
  end

  # recurse through all east neighbors, pack square and return when [:e].nil? == true
  def build_row(row, column = 0, output = [], rotate)
    square = find_square_by_position([column, row])
    square.threatened == threatened?(square)

    if rotate
      return output << square if square.neighbors[:w].nil?

      output << square
      build_row(row, column - 1, output, rotate)
    else
      return output << square if square.neighbors[:e].nil?

      output << square
      build_row(row, column + 1, output, rotate)
    end
    output
  end
end
