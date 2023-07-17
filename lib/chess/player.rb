# player.rb.rb
# frozen_string_literal: true

module Chess
  # Chess player object
  class Player
    attr_accessor :color, :name

    def initialize(name, color)
      @name = name
      @color = color
    end
  end
end
