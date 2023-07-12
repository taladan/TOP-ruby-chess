# main.rb
# frozen_string_literal: true

# Adjust load path to include needed directories
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/lib"
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/lib/chess"
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/lib/chess/pieces"

# Chess package requirements
require "display"
require "chess_piece"
require "colorize"
require "piece_handler"
require "square"
require "square_handler"
require "board"
require "version"
require "yaml"

# Overarching chess module
module Chess
  attr_reader :board

  # Game class object
  class Game
    def initialize
      @board = Board.new
      setup_board
    end

    def show_board
      @board.update_display
    end

    def version
      "Ruby Chess version: #{VERSION}"
    end

    private

    def setup_board
      standard_setup = YAML.safe_load(File.read("./lib/data/chess_standard_setup.yml"))
      standard_setup.each {|piece| @board.add_piece(piece[0], piece[1])}
    end
  end
end

Chess::Game.new
