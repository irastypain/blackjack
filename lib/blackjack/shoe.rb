# frozen_string_literal: true

module Blackjack
  class Shoe
    def initialize(deck, decks_count)
      @cards = deck.cards * decks_count
    end

    def empty?
      @cards.empty?
    end

    def dequeue
      @cards.shift
    end

    def shuffle!
      @cards.shuffle!
      self
    end
  end
end
