# frozen_string_literal: true

require 'blackjack/game'
require 'blackjack/round'
require 'blackjack/player'

describe Blackjack::Game do
  let(:player) do
    player = Blackjack::Player.new('John')
    player.take_money(Blackjack::Round::MIN_BET)
    player
  end

  it 'should make a new game' do
    game = Blackjack::Game.new(player)
    expect(game.status).to eq Blackjack::Game::STATUS_NEW
    expect(game.round).to be_nil
    expect(game.round_number).to eq 0
    expect(game.player).to eq player
    expect(game.actions).to include :new_round, :exit
    expect(game.round_ended?).to be_falsey
  end

  it 'should create a new round and start to play game' do
    game = Blackjack::Game.new(player)
    game.do_action(:new_round)

    expect(game.status).to eq Blackjack::Game::STATUS_PLAY
    expect(game.round).not_to be_nil
    expect(game.round_number).to eq 1
    expect(game.actions).to include :exit
    expect(game.round_ended?).to be_falsey
  end

  it 'should create a new round and play the game' do
    game = Blackjack::Game.new(player)
    game.do_action(:new_round)

    game.round.do_action(:bet)
    game.round.do_action(:deal)

    until game.round_ended?
      game.round.do_action(:hit)
    end

    expect(game.round_ended?).to be_truthy
  end

  it 'should stop the game' do
    game = Blackjack::Game.new(player)
    game.do_action(:new_round)
    game.do_action(:exit)

    expect(game.status).to eq Blackjack::Game::STATUS_STOP
    expect(game.actions).to eq %i[]
  end
end
