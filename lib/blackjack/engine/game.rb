# frozen_string_literal: true

module Blackjack
  class Game
    attr_reader :status, :round, :round_number, :player

    STATUS_NEW = :new
    STATUS_PLAY = :play
    STATUS_STOP = :stop

    def initialize(player)
      @player = player
      @dealer = Blackjack::Dealer.new('Smith')
      @shoe = Blackjack::Shoe.new(Blackjack::Deck.new, Blackjack::Settings::DECS_COUNT).shuffle!
      @status = STATUS_NEW
      @round_number = 0
    end

    def do_action(action, params = {})
      raise ArgumentError, "Unsupported action: #{action.inspect}" unless actions.include?(action)
      params.empty? ? send(action) : send(action, params)
      self
    end

    def actions
      return %i[exit] if @player.total_money < Blackjack::Settings::MIN_BET
      return %i[new_round exit] if @status == STATUS_NEW || @round.nil? || round_ended?
      return %i[] if @status == STATUS_STOP
      %i[exit]
    end

    def round_ended?
      return false if @round.nil?

      ended_statuses = [
        Blackjack::Round::STATUS_WIN,
        Blackjack::Round::STATUS_DRAW,
        Blackjack::Round::STATUS_LOSE
      ]
      ended_statuses.include?(@round.status)
    end

    private

    def new_round
      @round = Blackjack::Round.new(@dealer, @player, @shoe)
      @round_number = @round_number.succ
      @status = STATUS_PLAY
    end

    def exit
      @status = STATUS_STOP
    end
  end
end
