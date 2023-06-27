# knight.rb

# Knight chess piece
module Knight
  # Knight can move any combination of 2,1 squares
  POSSIBLE_MOVES = [
    [1, 2],
    [-1, 2],
    [1, -2],
    [-1, -2],
    [2, 1],
    [-2, 1],
    [2, -1],
    [-2, -1]
  ]
end
