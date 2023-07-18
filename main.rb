# main.rb
# frozen_string_literal: true

# Adjust load path to include needed directories
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/lib"
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/lib/chess"
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/lib/chess/pieces"

# Overarching chess module
module Chess
  # Chess package requirements
  require "display"
  require "chess_piece"
  require "colorize"
  require "piece_handler"
  require "square"
  require "square_handler"
  require "board"
  require "player_handler"
  require "readline"
  require "version"
  require "yaml"
  # Game class object
  class Game
    attr_reader :board, :player1, :player2

    def initialize
      @board = Board.new
      @game_type = set_game_type
      @load_directory = "./lib/data/"
      @turn_number = 0
      @turn_history = {}
      @current_player = nil
      setup_board(@game_type)
      setup_players
      preamble
      game_loop
    end

    # Stuff to print before the game starts
    def preamble
      system("clear")||system("cls")
      Display.linebreak(1)
      Display.write(version)
      Display.write(author)
      Display.write(website)
    end

    # Main game loop
    def game_loop
      run = true
      while run
        # Display the board
        show_padded_board
        # Prompt player for piece to move
        moving_piece = Display.prompt_for_move(@current_player, "piece")
        # prompt player for square to move to 
        target_square = Display.prompt_for_move(@current_player, "target")
        run = false
      end
    end

    # Display current state of game board
    def show_board
      @board.update_display
    end

    # Pads the display of the board for prettier output
    def show_padded_board
      Display.linebreak(1)
      show_board
      Display.linebreak(3)
    end

    #
    # metadata stuff
    #

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

    #
    # methods that set game data/information
    #

    # Set the type of game: standard or custom
    def set_game_type
      @game_type = Display.query_for_game_type
    end

    # Load board starting positions
    def setup_board(type)
      standard_setup if type == "standard"
      custom_setup if type == "custom"
    end

    private

    # Load piece positions for a standard game of chess from yaml file located in
    # `./lib/data/chess_standard_setup.yml`
    def standard_setup
      yaml_file = YAML.safe_load(File.read("./lib/data/chess_standard_setup.yml"))
      yaml_file.each { |piece| @board.add_piece(piece[0], piece[1]) }
    end

    # Load piece positions for a custom game of chess from `.yml` file provided by user
    def custom_setup
      yaml_file = YAML.safe_load(File.read(Display.query_for_starting_file))
      yaml_file.each { |piece| @board.add_piece(piece[0], piece[1]) }
    end

    # asks for player names
    # creates player objects with appropriate colors
    # assigns player objects to instance variables
    # sets current player as Player 1
    def setup_players
      players = Display.query_for_players
      players.each_with_index do |player, index|
        @player1 = PlayerHandler.create_player(player, "white") if index.zero?
        @player2 = PlayerHandler.create_player(player, "black") unless index.zero?
      end
      @current_player = @player1
    end
    # End of class
  end
  # End of module
end

GAME = Chess::Game.new
