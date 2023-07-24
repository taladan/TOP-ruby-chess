# messages.rb
# frozen_string_literal: true

module Display
  # Contains messages that are displayed to the users
  class Messages
    attr_reader :messages

    def initialize(player=nil)
      prompt = "Chess: " unless player
      prompt = "Chess: #{player.name}," if player
      prompt_terminator = "> "
      @messages = {
        piece: "#{prompt} select piece (ex: a2) #{prompt_terminator}",
        target: "#{prompt} select target square (ex: a4) #{prompt_terminator}",
        invalid_square: "#{prompt} that is not a valid target.",
        invalid_piece: "#{prompt} that is not a valid piece.",
        player_two_prompt: "#{prompt} enter the name of player 2 #{prompt_terminator}",
        player_one_prompt: "#{prompt} enter the name of player 1 #{prompt_terminator}",
        game_type_prompt: "#{prompt} enter game type, (S)tandard or (C)ustom #{prompt_terminator}",
      }
    end

    def message(key)
      @messages[key]
    end
  end
end
