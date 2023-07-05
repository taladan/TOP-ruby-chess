# knight.rb
# frozen_string_literal: true


# Knight chess piece
module Knight
  class Knight < ChessPiece
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
end
