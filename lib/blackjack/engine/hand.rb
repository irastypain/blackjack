# frozen_string_literal: true

module Blackjack
  class Hand
    attr_reader :owner

    TWENTY_ONE = 21

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

    def points
      sorted_cards = cards.sort_by(&:points)
      has_many_aces = sorted_cards.count(&:ace?) > 1

      sorted_cards.reduce(0) do |sum, card|
        card_points = card.ace? && (has_many_aces || sum > 10) ? 1 : card.points
        sum + card_points
      end
    end

    def blackjack?
      @cards.count == 2 && twenty_one?
    end

    def possible_blackjack?
      @cards.count == 1 && [10, 11].include?(points)
    end

    def bust?
      points > TWENTY_ONE
    end

    def twenty_one?
      points == TWENTY_ONE
    end
  end
end
