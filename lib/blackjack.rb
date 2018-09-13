# frozen_string_literal: true

require 'blackjack/version'

require 'blackjack/errors/error'
require 'blackjack/errors/application_logic_error'

require 'blackjack/entities/card'
require 'blackjack/entities/player'
require 'blackjack/entities/dealer'

require 'blackjack/engine/deck'
require 'blackjack/engine/shoe'
require 'blackjack/engine/hand'
require 'blackjack/engine/round'
require 'blackjack/engine/game'

module Blackjack
  class << self
    def new_game(player)
      Blackjack::Game.new(player)
    end
  end
end
