# frozen_string_literal: true

require 'blackjack/player'

describe Blackjack::Player do
  it 'should make a player' do
    player = Blackjack::Player.new('John')
    expect(player.name).to eq 'John'
  end

  it 'should take 15 conventional units' do
    player = Blackjack::Player.new('John')
    expect(player.total_money).to eq 0
    player.take_money(15)
    expect(player.total_money).to eq 15
  end

  it 'should give 5 conventional units' do
    player = Blackjack::Player.new('John')
    player.take_money(10)
    expect(player.give_money(4)).to eq 4
    expect(player.total_money).to eq 6
  end

  it 'should raise error if not enough money' do
    player = Blackjack::Player.new('John')
    player.take_money(4)
    expect { player.give_money(5) }.to raise_error(RuntimeError)
  end
end
