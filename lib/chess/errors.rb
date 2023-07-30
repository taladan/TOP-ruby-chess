# lib/errors.rb
# frozen_string_literal: true

# Namespace for all chess errors
module ChessErrors
  # Base chess error
  class ChessError < StandardError
  end

  # An invalid Target square has been given
  class InvalidTargetPositionError < ChessError
    def initialize(msg = "Target square given is not a valid square.")
      super
    end
  end

  # An invalid piece name has been given
  class InvalidPieceNameError < ChessError
    def initialize(msg = "Invalid piece name given.")
      super
    end
  end

  # An invalid starting position has been given
  class InvalidStartingPositionError < ChessError
    def initialize(msg = "Invalid Starting Position.")
      super
    end
  end

  # An empty square has been found when a chess piece was expected
  class EmptySquareError < ChessError
    def initialize(msg = "No piece in starting square.")
      super
    end
  end

  # An illegal piece move has been given
  class IllegalMoveError < ChessError
    def initialize(msg = "Invalid move for indicated piece.")
      super
    end
  end

  # Invalid input given by user
  class InvalidInputError < ChessError
    def initialize(msg = "Invalid input given.")
      super
    end
  end

  # Player tried moving opponent's piece
  class OpponentsPieceChosenError < ChessError
    def initialize(msg = "You cannot move an opponent's piece.")
      super
    end
  end
  
  class PathError < ChessError
    def initialize(msg = "There is a piece in the way.")
      super
    end
  end
end
