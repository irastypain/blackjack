# frozen_string_literal: true

module Blackjack
  class Card
    attr_reader :literal, :suit

    SUITS = %i[clubs diamonds hearts spades].freeze
    LITERALS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze

    def initialize(literal, suit)
      raise "Unsupported literal '#{literal}'" unless LITERALS.include?(literal)
      @literal = literal
      raise "Unsupported suit '#{suit.inspect}'" unless SUITS.include?(suit)
      @suit = suit
    end

    def points
      case @literal
      when 'A'
        11
      when '10', 'J', 'Q', 'K'
        10
      else
        @literal.to_i
      end
    end

    def ace?
      @literal == 'A'
    end
  end
end
