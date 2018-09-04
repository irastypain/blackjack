# frozen_string_literal: true

module Blackjack
  class Player
    attr_reader :name, :total_money

    def initialize(name)
      @name = name
      @total_money = 0
    end

    def take_money(units)
      @total_money += units
    end

    def give_money(units)
      raise 'Not enough money' if @total_money < units
      @total_money -= units
      units
    end
  end
end
