# display.rb

require "colorize"

# Handle building display for chessboard
module Display
  # Create a displayable string of a row of squares.
  #
  # Syntax: #build_row_string(row)
  #
  # This receives an array of square objects, and returns a string for display
  # every square is treated as having a top, middle, and bottom pixel.  Contents of
  # each square will be displayed only in the middle pixel of the square.
  def build_row_string(row)
    output = { top: "", middle: "", bottom: "" }
    row.each do |square|
      output[:top] << square.pixels[:top]
      output[:middle] << square.pixels[:middle]
      output[:bottom] << square.pixels[:bottom]
    end
    output = add_row_header(row, output)
    [output[:top], output[:middle], output[:bottom]].join("\n")
  end

  # Output chess board to terminal
  #
  # Syntax: #update_display[(true)]
  #
  # If update_display is called without passing 'true', it displays the board
  # from the perspective of the white pieces being at the bottom of the board.
  #
  # If update_display is called with 'true', it displays the board from the
  # perspective of the black pieces being at the bottom of the board.

  def update_display(reverse: false)
    # Build by row
    if reverse
      # 0 - @rows - 1, black on bottom
      (0..@rows - 1).each { |row| puts build_row_string(build_row(row)) }
    else
      # @rows - 1..0, white on bottom
      (@rows - 1).downto(0) { |row| puts build_row_string(build_row(row)) }
    end
    print_column_labels
  end

  # Prints to screen and takes input from user for player names
  # takes no arguments
  # outputs a two element array
  def self.query_for_players
    output = []
    print "Enter the name of player 1: "
    output << gets.chomp
    print "Enter the name of player 2: "
    output << gets.chomp
    output
  end

  # Let users pick between a standard game of chess or a custom game
  def self.query_for_game_type
    input = ""
    output = "standard"
    until %w[s c standard custom].include?(input.downcase)
      print "Enter game type, (S)tandard or (C)ustom: "
      input = gets.chomp
    end
    output = "custom" if %w[C c custom].include?(input)
    output
  end

  # We want to allow players to load their own custom starting files,
  # this method explains our file format limitations and directs the 
  # user to (preferably) store the file in `./lib/data`, but will allow
  # the user to load the file from the directory they started the game from
  # or type in the load path of the file.  The file MUST be in `.yml` format.
  def self.query_for_starting_file
    file = ""
    puts "Ruby Chess uses the .yml format to store starting positions for chess pieces.
    To load a custom game setup, you can either copy your custom .yml file to `./lib/data/`,
    load the file from the directory you started the chess game from, or type the full path
    (including the file name) to your startup file."
    puts " "
    until File.exist?(file)
      puts "Please enter a valid (YAML) file name to load your custom starting positions from:"
      file = Readline.readline("Chess:> ", true).strip
    end
    file
  end

  private

  # insert newline
  # Add row number to head of row in middle pixel
  def add_row_header(row, output)
    output[:top].insert(0, "   ")
    output[:middle].insert(0, " #{row[0].position[1] + 1} ")
    output[:bottom].insert(0, "   ")
    output
  end

  def linebreak
    puts " "
  end

  # set color of string to background of square
  def set_color(string, color)
    if color == "black"
      string.on_black
    else
      string.on_white
    end
  end

  def print_column_labels
    linebreak
    printf("     ")
    column_labels.each do |label|
      printf("%-6s", label)
    end
    linebreak
  end
end
