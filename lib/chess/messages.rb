# messages.rb
# frozen_string_literal: true

module Display
  # Contains messages that are displayed to the users
  class Messages
    attr_reader :messages

    def initialize(player)
      prompt = "Chess: #{player.name},"
      prompt_terminator = "> "
      @messages = {
        piece: "#{prompt} select piece (ex: a2) #{prompt_terminator}",
        target: "#{prompt} select target square (ex: a4) #{prompt_terminator}",
        invalid_square: "#{prompt} that is not a valid target.",
        invalid_piece: "#{prompt} that is not a valid piece.",
        player_one_prompt: "#{prompt} enter the name of player 1",
        player_two_prompt: "#{prompt} enter the name of player 2",
      }
    end

    def message(key)
      @messages[key]
    end
  end
end
