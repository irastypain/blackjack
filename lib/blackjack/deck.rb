# frozen_string_literal: true

module Blackjack
  class Deck
    def initialize
      @cards = make_cards
    end

    def cards
      @cards.clone
    end

    private

    def make_cards
      Card::SUITS.reduce([]) do |cards, suit|
        cards + Card::LITERALS.map { |literal| Card.new(literal, suit) }
      end
    end
  end
end
