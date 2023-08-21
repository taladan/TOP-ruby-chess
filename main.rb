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
  require "path"
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
      # build array of chess errors to rescue
      @errors = ChessErrors.constants.map do |e|
        ChessErrors.const_get(e)
      end.select { |e| e.is_a?(Class) && e < StandardError }

      setup_board(@game_type)
      setup_players
      game_loop
    end

    # Stuff to print before the game starts
    def preamble
      system("clear") || system("cls")
      Display.linebreak(1)
      puts Display.write(version)
      puts Display.write(author)
      puts Display.write(website)
    end

    # main game loop
    def game_loop
      run = true
      while run
        preamble
        turn
      end
    end

    # display current state of game board
    def show_board(option)
      @board.update_display(option)
    end

    # pads the display of the board for prettier output
    def show_padded_board(option=false)
      Display.linebreak(1)
      show_board(option)
      Display.linebreak(2)
    end

    #
    # metadata stuff
    #

    # printable string containing author information
    def author
      "Author: #{AUTHOR}"
    end

    # printable string containing website information
    def website
      "Game website: #{WEBSITE}"
    end

    # printable string containing versioning information
    def version
      "Ruby Chess version: #{VERSION}"
    end

    #
    # methods that set game data/information
    #

    # set the type of game: standard or custom
    def set_game_type
      preamble
      Display.linebreak
      @game_type = Display.query_for_game_type
    end

    # load board starting positions
    def setup_board(type)
      standard_setup if type == "standard"
      custom_setup if type == "custom"
    end

    private

    # use current player to determine how to display the board
    def pick_board
      show_padded_board(true) if @current_player.color == "black"
      show_padded_board if @current_player.color == "white"
    end

    # display board and prompt players for moves, then record those moves
    def turn
      pick_board
      begin
        player_move = PlayerHandler.player_move(@current_player, @board)
      rescue *@errors => ex
        puts("#{ex.message}")
        sleep(1)
      else
        # swap players
        @current_player = swap_players
      end

      # record_moves(player1_move, player2_move)
    end

    # store one full turn, which includes both players moves - source and destination
    def record_moves(player1_move, player2_move, attack = false)
      @turn_history[@turn_number] = [player1_move, player2_move]
      @turn_number += 1
    end

    # Load piece positions for a standard game of chess from yaml file located in
    # `./lib/data/chess_standard_setup.yml`
    def standard_setup
      yaml_file = YAML.safe_load(File.read("./lib/data/chess_standard_setup.yml"))
      yaml_file.each do |piece|
        # Creates the piece and adds to the board
        new_piece = @board.add_piece(piece[0], piece[1])

        # Add piece object to @board.pieces array
        @board.pieces << new_piece
      end
    end

    # Load piece positions for a custom game of chess from `.yml` file provided by user
    def custom_setup
      yaml_file = YAML.safe_load(File.read(Display.query_for_starting_file))
      yaml_file.each do |piece| 
        # Creates the piece and adds to the board
        new_piece = @board.add_piece(piece[0], piece[1])

        # Add piece object to @board.pieces array
        @board.pieces << new_piece
      end
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

    # Changes the current player
    def swap_players
      return @player2 if @current_player == @player1
      return @player1 if @current_player == @player2
    end
    # End of class
  end
  # End of module
end

GAME = Chess::Game.new
