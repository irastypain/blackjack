# frozen_string_literal: true

module Blackjack
  class Card
    attr_reader :literal, :suit

    ALLOWED_SUITS = %i[clubs diamonds hearts spades].freeze
    ALLOWED_LITERALS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze

    def initialize(literal, suit)
      raise ArgumentError, "Unsupported literal '#{literal}'" unless ALLOWED_LITERALS.include?(literal)
      @literal = literal
      raise ArgumentError, "Unsupported suit '#{suit.inspect}'" unless ALLOWED_SUITS.include?(suit)
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
