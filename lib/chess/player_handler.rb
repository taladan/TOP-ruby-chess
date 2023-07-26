# player_handler.rb.rb
# frozen_string_literal: true


# Player Handler holds commands that deal with
# players:  Moves, prompts, messaging, etc.
module PlayerHandler
  require "square_handler"
  require "player"
  include ChessErrors

  def self.create_player(name, color)
    Chess::Player.new(name, color)
  end

  # Handles dealing with player movement
  def self.player_move(player, board)
    piece = PlayerHandler.choose_piece(player)
    target = PlayerHandler.choose_target(player)

    raise OpponentsPieceChosenError unless self.validate_piece(piece, player, board)

    board.move_piece(piece, target, player)
    [piece, target]
  end

  # Prompt player for piece to move, validate and return piece (if valid)
  def self.choose_piece(player)
    Display.prompt_for_move(player, :piece)
  end

  # prompt for target square to place piece
  # then validate and return the square object
  def self.choose_target(player)
    Display.prompt_for_move(player, :target)
  end

  ####  THIS SECTION NEEDS WORK

  # Ensure the player is picking a valid piece
  # Valid pieces must:
  # - CANNOT be nil
  # - MUST allow player to move (be of the same color as the player)
  def self.validate_piece(square_name, player, board)
    square = board.find_square_by_name(square_name)
    piece = square.contents
    !piece.nil? && piece.can_move?(player)
  end
end
