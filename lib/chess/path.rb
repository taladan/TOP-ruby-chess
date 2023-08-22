# path.rb

module PieceHandler
  # path handling
  class Path
    include SquareHandler
    def initialize(board)
      @path_board = board
    end

    # return true if no pieces in path, false if pieces in path
    #
    # for path finding, I am using compass directionals to track desired piece movement
    # i.e. nw, n, ne, e, se, s, sw, w
    # with the direction, we are able to traverse the neighboring squares
    # in the direction of movement and test for the presence of a piece within the path of the moving piece
    # pawns, knights, and kings have special rules for movements
    def clear?(from, to, player)
      direction = determine_direction(from, to)
      piece = from.contents
      path = get_path(from, to, direction) unless piece.is_a?(Pieces::Knight)

      # pawns can only move n (if white), s (if black) and only attack ne/nw (if white), se/sw (if black)
      if piece.is_a?(Pieces::Pawn)
        pawn_rules(piece, direction, path)

      # Ensure target square is opponent's piece when occupied
      elsif piece.instance_of?(Pieces::Knight)
        knight_rule(piece, to)

      # Possible use for castling
      elsif piece.instance_of?(Pieces::King)
        # check for length of path if path == 3, MUST be castle
        castle_rule unless piece.has_moved && %i[e w].include?(direction) && path == 3

        # otherwise normal king check
        king_rule(piece, path)

      # Queen, Bishop, Rook
      else
        piece_rule(player, path)
      end
    end

    # rules for pawn movement
    def pawn_rules(piece, direction, path)
      # white pawns can move: n, ne, nw
      # black pawns can move: s, se, sw
      raise IllegalMoveError unless piece.can_move_direction?(direction)

      if %i[n s].include?(direction)
        pawn_move(piece, path)
      # attack only one space
      elsif %i[ne se nw sw].include?(direction)
        pawn_attack(piece, path)
      else
        raise InvalidTargetPositionError
      end
    end

    # pawn moves: can move 1 or 2 if pawn hasn't moved already, can't move if target square is occupied
    def pawn_move(piece, path)
      # if the pawn hasn't moved, it can move 1 or 2 spaces otherwise only 1 space at a time
      raise IllegalMoveError if path.drop(1).count > piece.move_limit(:move)

      # can't attack in a straight line
      return false if path.last.occupied?

      piece.has_moved = true unless piece.has_moved

      true
    end

    # This is here because king movement breaks everything
    # TODO: refactor so that Path is somehow inside the scope of the
    # board object
    def on_board?(square)
      @path_board.on_board?(square)
    end

    # pawn attacks: can only move one space, target square MUST have opponent's piece in it
    def pawn_attack(piece, path)
      raise IllegalMoveError if path.drop(1).count > piece.move_limit(:attack)

      target = path.last

      # can only be attacking, target must have opponent's piece in it
      return false unless target.occupied? && target.contents.color != piece.color

      true
    end

    # check if pawns are in a state that triggers en passant (https://www.chess.com/article/view/how-to-capture-en-passant)
    # this checks to see if the conditions for an en passant offer should be made to the opponent of the moving player
    def en_passant?(piece, path)
      # TODO: All of this is old code and needs to be refactored
      # must have been triggered by double move
      path.count == 3 && path.last.position[0] == piece.en_passant_rank && path.last.en_passant_neighbors?
    end

    # en passant goes here
    def en_passant
      # TODO: All of this is old code and needs to be refactored
      # offer opponent a chance for en passant
      # if yes, that becomes opponent's movement and play goes back to
      # the player whose movement initiated the en passant
    end

    # rules for knight movement
    def knight_rule(piece, target)
      return false if target.occupied? && target.contents.color == piece.color

      true
    end

    # rules for king movement
    def king_rule(piece, path)
      # TODO: All of this is old code and needs to be refactored
      target = path.last

      # king CANNOT move into a threatened square
      path.drop(1).each do |square|
        raise MoveIntoCheckError if threatened?(square, piece.color)
      end

      return false if target.occupied? && target.contents.color == piece.color

      true
    end

    # castling checks go here
    def castle_rule
      # TODO: All of this is old code and needs to be refactored
      true
    end

    # rules for all other movement
    def piece_rule(player, path)
      output = true
      path.each do |square|
        # We don't test the square we're starting from
        next if square == path.first

        if square == path.last
          # allow player to take piece if square is occupied by opponent's piece
          output = true if square.occupied? && square.contents.color != player.color
        elsif square.occupied?
          output = false
        end
        # All squares between `from` and `to` non-inclusive must be empty
      end
      output
    end

    # return the symbol representative of the direction the piece is moving
    #
    # determining direction is simple enough by using array math to test for an increase or decrease
    # in value of either the row indicator or the column indicator for a particular square
    def determine_direction(from, to)
      row = from.x <=> to.x
      col = from.y <=> to.y

      case [row, col]
      # column from gt column to
      when [0, 1]
        :s
      # row from gt row to
      when [1, 0]
        :w
      # row from gt row to && col from gt col to
      when [1, 1]
        :sw
      # row from lt row to
      when [-1, 0]
        :e
      # row from lt row to && col from lt col to
      when [-1, -1]
        :ne
      # row from gt row to && col from lt col to
      when [1, -1]
        :nw
      # row from lt row to && col from gt col to
      when [-1, 1]
        :se
      # col from lt col to
      when [0, -1]
        :n
      end
    end

    # recursively get array of squares that form path between from square and to square
    def get_path(from, to, direction, current_position = from.position, output = [])
      # TODO: All of this is old code and needs to be refactored
      square = @path_board.retrieve_square(current_position)
      output << square
      return output if current_position == to.position

      next_position = @path_board.retrieve_square(square.neighbors[direction]).position
      get_path(from, to, direction, next_position, output)
    end

    # End of class
  end
  # End of module
end
