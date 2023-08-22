# board.rb
# frozen_string_literal: true

module Chess 

  # Generate a graph called "Board" of nodes called "squares"
  class Board
    include Display
    include PieceHandler
    include SquareHandler

    attr_accessor :pieces, :squares
    attr_reader :columns, :display, :rows

    def initialize(columns = 8, rows = 8)
      # Define instance variables
      @board = self
      @columns = columns
      @pieces = []
      @rows = rows
      @squares = []
      @valid_square_names = nil
      @valid_piece_names = %w[K Q B N R P k q b n r p]

      # run code on initialization
      generate_board
    end

    # test if [n,m] is within confines of board
    def on_board?(position)
      return nil if position.nil?

      if position.kind_of?(Array)
        rows = (0..@rows - 1).to_a
        cols = (0..@columns - 1).to_a
        row = position[1]
        col = position[0]
        rows.include?(row) && cols.include?(col)
      elsif position.kind_of?(String)
        retrieve_square(position).kind_of?(Square)
      elsif position.is_a?(Square)
        true
      else
        raise InvalidInputError
      end
    end

    private

    # Return true if the square is occupied
    def occupied?(square)
      return true if square.occupied?
    end

    # return array of lettered columns from a - zz
    def column_labels
      alphas = ("a".."zz").to_a
      array = []
      @columns.times do |column|
        array << alphas[column]
      end
      array
    end

    # return an array of formatted column and row names - ex `a1 - h8`
    def combine_columns_and_rows
      array = []
      cols = column_labels
      rows = make_rows
      cols.each do |col|
        rows.each do |row|
          array << "#{col}#{row}"
        end
      end
      array
    end

    # create board of squares return nil
    def generate_board
      # make squares
      @valid_square_names = combine_columns_and_rows.to_a
      @valid_square_names.each { |square| @squares << Square.new(square) }

      # gives the squares positions in space
      assign_square_positions(generate_2d_array)

      # calculate neighbors and assign a color to square
      @squares.each do |square|
        assign_neighbors(square)
        square.assign_color
      end
      nil
    end

    # generate a 2d array where the first element iterates [0,0], [1,0], [2,0], [3,0]...etc.
    def generate_2d_array
      output = []
      (@columns * @rows).times { |num| output << [num / @columns, num % @rows] }
      output
    end

    # create an array of row numbers from 1
    def make_rows
      array = []
      @rows.times do |row|
        array << (row + 1)
      end
      array
    end
  end
end
