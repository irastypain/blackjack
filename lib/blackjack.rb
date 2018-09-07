# frozen_string_literal: true

require 'blackjack/card'
require 'blackjack/deck'
require 'blackjack/shoe'
require 'blackjack/player'
require 'blackjack/dealer'
require 'blackjack/hand'
require 'blackjack/round'
require 'blackjack/game'

module Blackjack
  class << self
    def new_game(player)
      Blackjack::Game.new(player)
    end
  end
end
