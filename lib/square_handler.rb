# square_handler.rb
# Square Logic module

module Squares
  # return total number of squares in board
  def count
    squares.length
  end

  # return square by name format columnrow - `a1`
  def find_square_by_name(name)
    @squares.each do |square|
      return square if square.name == name
    end
    nil
  end

  # return square object by positional space -  takes an array
  def find_square_by_position(position)
    @squares.each do |square|
      return square if square.position == position
    end
  end

  # returns the name of the square in position [col, row]
  def get_name_by_position(position)
    return nil if position.nil?

    square = find_square_by_position(position)
    square.name
  end

  def get_position_by_name(name)
    return nil if name.nil?

    square = find_square_by_name(name)
    square.position
  end

  private

  # This is a little raw.  If I were to refactor this, I'd set up a setter/getter function for neighbors in square.
  # This sets an unweighted, undirected edge between square and its `key` neighbor
  def add_edge(square, neighbor, key)
    opposites = { n: 's', ne: 'sw', e: 'w', se: 'nw', s: 'n', sw: 'ne', w: 'e', nw: 'se' }
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

  # this will give squares positional information as an easier way to reference as a 2d array as well as name info
  # allows for some math operations like assign_neighbors
  def assign_square_positions
    arr2d = generate_2d_array
    @squares.each_with_index do |square, index|
      square.assign_positions(arr2d[index])
    end
    nil
  end

  # recurse through all east neighbors, pack square and return when [:e].nil? == true
  def build_row(row, column = 0, output = [])
    square = find_square_by_position([column, row])
    return output << square if square.neighbors[:e].nil?

    output << square
    build_row(row, column + 1, output)
  end
end
