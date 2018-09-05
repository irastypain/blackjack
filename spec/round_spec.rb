# frozen_string_literal: true

require 'blackjack/round'
require 'blackjack/player'
require 'blackjack/dealer'
require 'blackjack/deck'
require 'blackjack/shoe'

describe Blackjack::Round do
  let(:player) { Blackjack::Player.new('John') }
  let(:dealer) { Blackjack::Dealer.new('Smith') }

  def prepare_round(cards)
    deck = instance_double(Blackjack::Deck, cards: cards)
    shoe = Blackjack::Shoe.new(deck, 1)
    round = Blackjack::Round.new(dealer, player, shoe)
    round.do_action(:bet)
         .do_action(:deal)
  end

  describe 'life cycle' do
    it 'should check statuses from :new to :win' do
      player.take_money(Blackjack::Round::MIN_BET)
      cards = [
        Blackjack::Card.new('4', :clubs),
        Blackjack::Card.new('9', :diamonds),
        Blackjack::Card.new('Q', :hearts),
        Blackjack::Card.new('5', :clubs),
        Blackjack::Card.new('8', :spades)
      ]
      deck = instance_double(Blackjack::Deck, cards: cards)
      shoe = Blackjack::Shoe.new(deck, 1)
      round = Blackjack::Round.new(dealer, player, shoe)

      expect(round.status).to eq Blackjack::Round::STATUS_NEW
      round.do_action(:bet)
      expect(round.status).to eq Blackjack::Round::STATUS_BET_ACCEPTED
      round.do_action(:deal)
      expect(round.status).to eq Blackjack::Round::STATUS_PLAYER_PLAYS
      round.do_action(:hit)
      expect(round.status).to eq Blackjack::Round::STATUS_PLAYER_PLAYS
      round.do_action(:stand)
      expect(round.status).to eq Blackjack::Round::STATUS_WIN
    end

    it 'should check full state' do
      player.take_money(Blackjack::Round::MIN_BET)
      cards = [
        Blackjack::Card.new('A', :clubs),
        Blackjack::Card.new('9', :diamonds),
        Blackjack::Card.new('5', :hearts),
        Blackjack::Card.new('4', :clubs),
        Blackjack::Card.new('8', :spades)
      ]
      round = prepare_round(cards)
      round.do_action(:hit)
      round.do_action(:stand)

      expect(round.status).to eq Blackjack::Round::STATUS_WIN
      expect(round.winning).to eq Blackjack::Round::MIN_BET
      expect(round.total_bet).to eq Blackjack::Round::MIN_BET
      expect(round.actions).to eq Blackjack::Round::EMPTY_ACTIONS
      expect(round.player_cards).to include(cards[0], cards[2], cards[3])
      expect(round.dealer_cards).to include(cards[1], cards[4])
    end
  end

  describe 'win' do
    context 'when player has blackjack' do
      context 'when dealer has not blackjack' do
        it 'should win with 3 to 2' do
          player.take_money(Blackjack::Round::MIN_BET)
          started_money = player.total_money

          cards = [
            Blackjack::Card.new('A', :spades),
            Blackjack::Card.new('4', :hearts),
            Blackjack::Card.new('K', :clubs)
          ]
          round = prepare_round(cards)

          winning = Blackjack::Round::MIN_BET / 2 * 3
          expect(round.status).to eq Blackjack::Round::STATUS_WIN
          expect(round.winning).to eq winning
          expect(round.total_bet).to eq Blackjack::Round::MIN_BET
          expect(round.actions).to eq Blackjack::Round::EMPTY_ACTIONS
          expect(player.total_money).to eq started_money + winning
        end
      end
    end

    context 'when player has not blackjack' do
      context 'when player has points great than dealer' do
        it 'should win with 1 to 1' do
          player.take_money(Blackjack::Round::MIN_BET)
          started_money = player.total_money

          cards = [
            Blackjack::Card.new('4', :clubs),
            Blackjack::Card.new('9', :diamonds),
            Blackjack::Card.new('Q', :hearts),
            Blackjack::Card.new('5', :clubs),
            Blackjack::Card.new('8', :spades)
          ]
          round = prepare_round(cards)
          round.do_action(:hit)
          round.do_action(:stand)

          winning = Blackjack::Round::MIN_BET
          expect(round.status).to eq Blackjack::Round::STATUS_WIN
          expect(round.winning).to eq winning
          expect(round.total_bet).to eq Blackjack::Round::MIN_BET
          expect(round.actions).to eq Blackjack::Round::EMPTY_ACTIONS
          expect(player.total_money).to eq started_money + winning
        end
      end

      context 'when dealer has bust' do
        it 'should win with to 1 to 1' do
          player.take_money(Blackjack::Round::MIN_BET)
          started_money = player.total_money

          cards = [
            Blackjack::Card.new('8', :clubs),
            Blackjack::Card.new('7', :hearts),
            Blackjack::Card.new('Q', :diamonds),
            Blackjack::Card.new('8', :spades),
            Blackjack::Card.new('8', :hearts)
          ]
          round = prepare_round(cards)
          round.do_action(:stand)

          winning = Blackjack::Round::MIN_BET
          expect(round.status).to eq Blackjack::Round::STATUS_WIN
          expect(round.winning).to eq winning
          expect(round.total_bet).to eq Blackjack::Round::MIN_BET
          expect(round.actions).to eq Blackjack::Round::EMPTY_ACTIONS
          expect(player.total_money).to eq started_money + winning
        end
      end
    end
  end

  describe 'lose' do
    it 'should lose if dealer has blackjack' do
      player.take_money(Blackjack::Round::MIN_BET)

      cards = [
        Blackjack::Card.new('K', :hearts),
        Blackjack::Card.new('K', :spades),
        Blackjack::Card.new('9', :clubs),
        Blackjack::Card.new('2', :spades),
        Blackjack::Card.new('A', :hearts)
      ]
      round = prepare_round(cards)
      round.do_action(:hit)

      expect(round.status).to eq Blackjack::Round::STATUS_LOSE
      expect(round.winning).to eq 0
      expect(round.total_bet).to eq Blackjack::Round::MIN_BET
      expect(round.actions).to eq Blackjack::Round::EMPTY_ACTIONS
      expect(player.total_money).to eq 0
    end

    it 'should lose if player has bust' do
      player.take_money(Blackjack::Round::MIN_BET)

      cards = [
        Blackjack::Card.new('Q', :spades),
        Blackjack::Card.new('8', :diamonds),
        Blackjack::Card.new('7', :spades),
        Blackjack::Card.new('Q', :clubs)
      ]
      round = prepare_round(cards)
      round.do_action(:hit)

      expect(round.status).to eq Blackjack::Round::STATUS_LOSE
      expect(round.winning).to eq 0
      expect(round.total_bet).to eq Blackjack::Round::MIN_BET
      expect(round.actions).to eq Blackjack::Round::EMPTY_ACTIONS
      expect(player.total_money).to eq 0
    end

    it "should lose if player's points less than dealer's points" do
      player.take_money(Blackjack::Round::MIN_BET)

      cards = [
        Blackjack::Card.new('Q', :hearts),
        Blackjack::Card.new('Q', :clubs),
        Blackjack::Card.new('7', :diamonds),
        Blackjack::Card.new('9', :spades)
      ]
      round = prepare_round(cards)
      round.do_action(:stand)

      expect(round.status).to eq Blackjack::Round::STATUS_LOSE
      expect(round.winning).to eq 0
      expect(round.total_bet).to eq Blackjack::Round::MIN_BET
      expect(round.actions).to eq Blackjack::Round::EMPTY_ACTIONS
      expect(player.total_money).to eq 0
    end
  end

  describe 'draw' do
    it 'should be draw if player has blackjack and dealer has blackjack' do
      player.take_money(Blackjack::Round::MIN_BET)
      started_money = player.total_money

      cards = [
        Blackjack::Card.new('A', :spades),
        Blackjack::Card.new('A', :clubs),
        Blackjack::Card.new('J', :spades),
        Blackjack::Card.new('K', :hearts)
      ]
      round = prepare_round(cards)

      expect(round.status).to eq Blackjack::Round::STATUS_DRAW
      expect(round.winning).to eq 0
      expect(round.total_bet).to eq Blackjack::Round::MIN_BET
      expect(round.actions).to eq Blackjack::Round::EMPTY_ACTIONS
      expect(player.total_money).to eq started_money
    end

    it "should be draw if player's points and dealer's points equals" do
      player.take_money(Blackjack::Round::MIN_BET)
      started_money = player.total_money

      cards = [
        Blackjack::Card.new('8', :diamonds),
        Blackjack::Card.new('4', :clubs),
        Blackjack::Card.new('2', :hearts),
        Blackjack::Card.new('9', :hearts),
        Blackjack::Card.new('2', :spades),
        Blackjack::Card.new('10', :clubs),
        Blackjack::Card.new('7', :diamonds)
      ]
      round = prepare_round(cards)
      round.do_action(:hit)
      round.do_action(:hit)

      expect(round.status).to eq Blackjack::Round::STATUS_DRAW
      expect(round.winning).to eq 0
      expect(round.total_bet).to eq Blackjack::Round::MIN_BET
      expect(round.actions).to eq Blackjack::Round::EMPTY_ACTIONS
      expect(player.total_money).to eq started_money
    end
  end

  describe 'double' do
    context 'when player can double bet' do
      it 'should win with 1 to 1 (double bet)' do
        player.take_money(Blackjack::Round::MIN_BET * 2)
        started_money = player.total_money

        cards = [
          Blackjack::Card.new('6', :spades),
          Blackjack::Card.new('5', :hearts),
          Blackjack::Card.new('A', :spades),
          Blackjack::Card.new('Q', :clubs),
          Blackjack::Card.new('J', :diamonds),
          Blackjack::Card.new('Q', :spades)
        ]
        round = prepare_round(cards)
        round.do_action(:double)
        round.do_action(:stand)

        winning = Blackjack::Round::MIN_BET * 2
        expect(round.status).to eq Blackjack::Round::STATUS_WIN
        expect(round.winning).to eq winning
        expect(round.total_bet).to eq Blackjack::Round::MIN_BET * 2
        expect(round.actions).to eq Blackjack::Round::EMPTY_ACTIONS
        expect(player.total_money).to eq started_money + winning
      end
    end

    context 'when player can not double bet because not enough money' do
      it 'should win with 1 to 1 (without double bet)' do
        player.take_money(Blackjack::Round::MIN_BET)
        started_money = player.total_money

        cards = [
          Blackjack::Card.new('6', :spades),
          Blackjack::Card.new('5', :hearts),
          Blackjack::Card.new('A', :spades),
          Blackjack::Card.new('Q', :clubs),
          Blackjack::Card.new('J', :diamonds),
          Blackjack::Card.new('Q', :spades)
        ]
        round = prepare_round(cards)
        expect(round.actions).not_to include(:double)

        round.do_action(:hit)
        round.do_action(:stand)

        winning = Blackjack::Round::MIN_BET
        expect(round.status).to eq Blackjack::Round::STATUS_WIN
        expect(round.winning).to eq winning
        expect(round.total_bet).to eq Blackjack::Round::MIN_BET
        expect(round.actions).to eq Blackjack::Round::EMPTY_ACTIONS
        expect(player.total_money).to eq started_money + winning
      end
    end
  end
end
