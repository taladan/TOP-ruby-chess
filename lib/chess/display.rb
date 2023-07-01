# display.rb
require "colorize"

# Handle building display for chessboard
module Display
  # this receives an array of square objects, and returns a string for display
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

  # Display handled by @display
  def update_display
    # @rows - 1..0 because we"re searching by position
    # Build by row
    (@rows - 1).downto(0) { |row| puts build_row_string(build_row(row)) }
    linebreak
    print_column_labels
    linebreak
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
    printf("     ")
    column_labels.each do |label|
      printf("%-6s", label)
    end
  end
end
