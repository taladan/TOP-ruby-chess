# player_handler.rb.rb
# frozen_string_literal: true

require "player"

# Player Handler holds commands that deal with
# players:  Moves, prompts, messaging, etc.
module PlayerHandler
  def self.create_player(name, color)
    Chess::Player.new(name, color)
  end
end
