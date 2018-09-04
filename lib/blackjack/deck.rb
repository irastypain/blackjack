# frozen_string_literal: true

require 'blackjack/card'

module Blackjack
  class Deck
    attr_reader :cards

    def initialize
      @cards = make_cards
    end

    private

    def make_cards
      Card::SUITS.reduce([]) do |cards, suit|
        cards + Card::LITERALS.map { |literal| Card.new(literal, suit) }
      end
    end
  end
end
