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
require "player_handler"
require "version"
require "yaml"

# Overarching chess module
module Chess
  # Game class object
  class Game
    attr_reader :board, :player1, :player2

    def initialize
      @board = Board.new
      @game_type = "standard"
      @turn_number = 0
      @turn_history = {}
      setup_board
      setup_players
    end

    # Display current state of game board
    def show_board
      @board.update_display
    end

    # Printable string containing author information
    def author
      "Author: #{AUTHOR}"
    end

    # Printable string containing website information
    def website
      "Game website: #{WEBSITE}"
    end

    # Printable string containing versioning information
    def version
      "Ruby Chess version: #{VERSION}"
    end

    private

    # Load standard board starting positions
    def setup_board
      standard_setup = YAML.safe_load(File.read("./lib/data/chess_standard_setup.yml"))
      standard_setup.each {|piece| @board.add_piece(piece[0], piece[1])}
    end

    # asks for player names
    # creates player objects with appropriate colors
    # assigns player objects to instance variables
    def setup_players
      players = Display.query_for_players
      players.each_with_index do |player, index|
        @player1 = PlayerHandler.create_player(player, "white") if index.zero?
        @player2 = PlayerHandler.create_player(player, "black") unless index.zero?
      end
    end
    # End of class
  end
  # End of module
end

GAME = Chess::Game.new
