# lib/errors.rb
# frozen_string_literal: true

# Plan to move forward:
# - create a directory for errors
# - break all errors out into their own file
# - figure out how to aggregate all error files in that directory into `errors.rb`

# Namespace for all chess errors
module ChessErrors
  # base chess error
  class ChessError < StandardError
  end

  # an invalid Target square has been given
  class InvalidTargetPositionError < ChessError
    def initialize(msg = "Target square given is not a valid square.")
      super
    end
  end

  # an invalid piece name has been given
  class InvalidPieceNameError < ChessError
    def initialize(msg = "Invalid piece name given.")
      super
    end
  end

  # an invalid starting position has been given
  class InvalidStartingPositionError < ChessError
    def initialize(msg = "Invalid Starting Position.")
      super
    end
  end

  # an empty square has been found when a chess piece was expected
  class EmptySquareError < ChessError
    def initialize(msg = "No piece in starting square.")
      super
    end
  end

  # an illegal piece move has been given
  class IllegalMoveError < ChessError
    def initialize(msg = "Invalid move for indicated piece.")
      super
    end
  end

  # invalid input given by user
  class InvalidInputError < ChessError
    def initialize(msg = "Invalid input given.")
      super
    end
  end

  # player tried moving opponent's piece
  class OpponentsPieceChosenError < ChessError
    def initialize(msg = "You cannot move an opponent's piece.")
      super
    end
  end

  # path is not clear
  class PathError < ChessError
    def initialize(msg = "There is a piece in the way.")
      super
    end
  end
end
