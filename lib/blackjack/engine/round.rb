# frozen_string_literal: true

module Blackjack
  class Round
    STATUS_NEW = :new
    STATUS_BET_ACCEPTED = :bet_accepted
    STATUS_DEALT = :dealt
    STATUS_PLAYER_PLAYS = :player_plays
    STATUS_DEALER_PLAYS = :dealer_plays
    STATUS_WIN = :win
    STATUS_LOSE = :lose
    STATUS_DRAW = :draw

    EMPTY_ACTIONS = %i[].freeze

    WIN_COEFFICIENT_2_TO_1 = 2
    WIN_COEFFICIENT_3_TO_2 = 1.5
    WIN_COEFFICIENT_1_TO_1 = 1
    DRAW_COEFFICIENT = 0
    LOSE_COEFFICIENT = 0

    def initialize(dealer, player, shoe)
      @dealer = dealer
      @player = player
      @shoe = shoe
      init_state
    end

    def do_action(action, params = {})
      raise ArgumentError, "Unsupported action: #{action.inspect}" unless @state[:actions].include?(action)
      params.empty? ? send(action) : send(action, params)
      self
    end

    def status
      @state[:status]
    end

    def winning
      @state[:winning]
    end

    def total_bet
      @state[:total_bet]
    end

    def player_cards
      @state[:player_hand].cards
    end

    def player_points
      @state[:player_hand].points
    end

    def dealer_cards
      @state[:dealer_hand].cards
    end

    def dealer_points
      @state[:dealer_hand].points
    end

    def actions
      @state[:actions].freeze
    end

    private

    def init_state
      @state = {
        status: STATUS_NEW,
        winning: 0,
        total_bet: 0,
        dealer_hand: Blackjack::Hand.new(@dealer),
        player_hand: Blackjack::Hand.new(@player),
        actions: %i[bet]
      }
    end

    def update_state(params = {})
      params.each { |param, value| @state[param] = value }
    end

    def bet
      player_bet = @player.give_money(Blackjack::Settings::MIN_BET)
      new_total_bet = @state[:total_bet] + player_bet
      update_state(total_bet: new_total_bet)

      actions = can_player_bet? ? %i[bet deal] : %i[deal]
      update_state(status: STATUS_BET_ACCEPTED, actions: actions)
    end

    def deal
      push_card_from_shoe(@state[:player_hand])
      push_card_from_shoe(@state[:dealer_hand])
      push_card_from_shoe(@state[:player_hand])

      update_state(status: STATUS_DEALT, actions: EMPTY_ACTIONS)

      player_plays
    end

    def player_plays
      player_hand = @state[:player_hand]
      dealer_hand = @state[:dealer_hand]

      if player_hand.blackjack?
        if dealer_hand.possible_blackjack?
          stand
        else
          end_round_with(STATUS_WIN, WIN_COEFFICIENT_3_TO_2)
        end
      else
        actions = @player.total_money >= @state[:total_bet] ? %i[double hit stand] : %i[hit stand]
        update_state(status: STATUS_PLAYER_PLAYS, actions: actions)
      end
    end

    def double
      current_bet = @state[:total_bet]
      player_bet = @player.give_money(current_bet)
      update_state(total_bet: current_bet + player_bet)
      hit
    end

    def hit
      player_hand = @state[:player_hand]
      push_card_from_shoe(player_hand)

      if player_hand.bust?
        end_round_with(STATUS_LOSE, LOSE_COEFFICIENT)
      elsif player_hand.has_max_win_points?
        stand
      else
        update_state(status: STATUS_PLAYER_PLAYS, actions: %i[hit stand])
      end
    end

    def stand
      update_state(status: STATUS_DEALER_PLAYS, actions: EMPTY_ACTIONS)
      dealer_plays
    end

    def dealer_plays
      player_hand = @state[:player_hand]
      dealer_hand = @state[:dealer_hand]
      push_card_from_shoe(dealer_hand)

      if dealer_hand.blackjack?
        if player_hand.blackjack?
          end_round_with(STATUS_DRAW, DRAW_COEFFICIENT)
        else
          end_round_with(STATUS_LOSE, LOSE_COEFFICIENT)
        end
      else
        dealer_take_cards_while_can

        if dealer_hand.bust? || dealer_hand.points < player_hand.points
          end_round_with(STATUS_WIN, WIN_COEFFICIENT_1_TO_1)
        elsif dealer_hand.points == player_hand.points
          end_round_with(STATUS_DRAW, DRAW_COEFFICIENT)
        else
          end_round_with(STATUS_LOSE, LOSE_COEFFICIENT)
        end
      end
    end

    def dealer_take_cards_while_can
      dealer_hand = @state[:dealer_hand]
      until dealer_hand.bust? || dealer_hand.points >= Blackjack::Settings::DEALER_ENOUGH_POINTS
        push_card_from_shoe(dealer_hand)
      end
    end

    def push_card_from_shoe(hand)
      card = @shoe.dequeue
      hand.push(card)
    end

    def can_player_bet?
      @player.total_money >= Blackjack::Settings::MIN_BET && @state[:total_bet] != Blackjack::Settings::MAX_BET
    end

    def end_round_with(status, coefficient)
      update_state(status: status, winning: calc_winning(coefficient), actions: EMPTY_ACTIONS)

      case status
      when STATUS_DRAW
        return_bet
      when STATUS_WIN
        pay_winning
      end
    end

    def calc_winning(multiplier)
      @state[:total_bet] * multiplier
    end

    def return_bet
      @player.take_money(@state[:total_bet])
    end

    def pay_winning
      total_amount = @state[:total_bet] + @state[:winning]
      @player.take_money(total_amount)
    end
  end
end
