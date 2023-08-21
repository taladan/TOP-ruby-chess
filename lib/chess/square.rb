# square.rb
# frozen_string_literal: true

require "colorize"
require "square_handler"

module SquareHandler
  # a graph node named 'square'
  class Square
    include PieceHandler
    include SquareHandler
    attr_reader :x, :y
    attr_accessor :name,
                  :neighbors,
                  :position,
                  :contents,
                  :color,
                  :dist,
                  :prev,
                  :threatened,
                  :threats

    def initialize(name)
      @name = name
      @neighbors = { n: nil, ne: nil, e: nil, se: nil, s: nil, sw: nil, w: nil, nw: nil }
      @position = []
      @contents = nil
      @color = nil
      @x = nil
      @y = nil
      @threatened = false
      @threats = nil
      # Required for Knight's Travails
      @dist = 0
      @prev = nil
    end

    # assign square color based on position within board.  Upper left & Lower right squares == whitejj
    def assign_color
      if (@position[0].even? && @position[1].even?) || (@position[0].odd? && @position[1].odd?)
        @color = "black"
      elsif (@position[0].even? && @position[1].odd?) || (@position[0].odd? && @position[1].even?)
        @color = "white"
      end
    end

    # return true/false if square occupied
    def occupied?
      !@contents.nil?
    end

    # build square display
    def pixels
      pad = "      ".on_black if @color == "black"
      pad = "      ".on_white if @color == "white"
      pad = "      ".on_yellow if @threatened
      mid = "  #{@contents.icon}   ".on_black if @color == "black" && !@contents.nil?
      mid = "  #{@contents.icon}   ".on_white if @color == "white" && !@contents.nil?
      mid = "  #{@contents.icon}   ".on_yellow if @threatened && !@contents.nil?
      # uncomment for square names in center of each square
      # mid = "  #{name}  ".on_black if @color == "black" && @contents.nil?
      # mid = "  #{name}  ".on_white if @color == "white" && @contents.nil?
      mid = pad.on_black if @color == "black" && @contents.nil?
      mid = pad.on_white if @color == "white" && @contents.nil?
      mid = pad.on_yellow if @threatened && @contents.nil?

      { top: pad, middle: mid, bottom: pad }
    end

    # assigns X and Y coordinates of square from passed 2 value array
    def assign_positions(arr)
      @position = arr
      @x = @position[0]
      @y = @position[1]
    end

    # E/W neighboring squares must be occupied with an opponents pawn
    def en_passant_neighbors?
      en_passant = false
      neighbors.each do |neighbor|
        name = neighbor[0]
        square = neighbor[1]
        next unless %i[e w].include?(name)

        if square.occupied? && square.contents.instance_of?(Pawn) && square.contents.color != @color
          en_passant = true
        else
          en_passant = false unless en_passant == true
        end
      end
  en_passant
    end
  end
end