# frozen_string_literal: true

module Blackjack
  class Hand
    attr_reader :owner

    def initialize(owner)
      @owner = owner
      @cards = []
    end

    def cards
      @cards.clone
    end

    def push(card)
      @cards.push(card)
    end

    def pop
      @cards.pop
    end

    def flush
      @cards.clear
    end

    def empty?
      @cards.empty?
    end
  end
end
