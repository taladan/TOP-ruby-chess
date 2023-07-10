# main.rb
# frozen_string_literal: true

# Chess package requirements
require "board"
require "display"
require "piece_handler"
require "version"

# Overarching chess module
module Chess
  # Game class object
  class Game
    include Board
    include Display
    include PieceHandler
    include Version
    include ChessPiece

    def initialize
      # code goes here
    end

    def some_method
      # code goes here
    end
  end
end
