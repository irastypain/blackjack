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
      suits.reduce([]) do |cards, suit|
        cards + literals.map { |literal| Card.new(literal, suit) }
      end
    end

    def literals
      Card::ALLOWED_LITERALS
    end

    def suits
      Card::ALLOWED_SUITS
    end
  end
end
