# lib/errors.rb
# frozen_string_literal: true

# Namespace for all chess errors
module ChessErrors
  # An invalid Target square has been given
  class InvalidTargetPositionError < StandardError
    def initialize(msg = "Target square given is not a valid square.")
      super
    end
  end

  # An invalid piece name has been given
  class InvalidPieceNameError < StandardError
    def initialize(msg = "Invalid piece name given.")
      super
    end
  end

  # An invalid starting position has been given
  class InvalidStartingPositionError < StandardError
    def initialize(msg = "Invalid Starting Position")
      super
    end
  end

  # An empty square has been found when a chess piece was expected
  class EmptySquareError < StandardError
    def initialize(msg = "No piece in starting square")
      super
    end
  end

  # An illegal piece move has been given
  class IllegalMoveError < StandardError
    def initialize(msg = "Invalid move for indicated piece.")
      super
    end
  end

  # Invalid input given by user
  class InvalidInputError < StandardError
    def initialize(msg = "Invalid input given")
      super
    end
  end
end
