# frozen_string_literal: true

require 'blackjack/hand'
require 'blackjack/player'
require 'blackjack/card'

describe Blackjack::Hand do
  let(:player) { Blackjack::Player.new('Smith') }
  let(:jack_of_clubs) { Blackjack::Card.new('J', :clubs) }
  let(:ace_of_spades) { Blackjack::Card.new('A', :spades) }

  it 'should make an empty hand' do
    hand = Blackjack::Hand.new(player)
    expect(hand.owner).to eq player
    expect(hand.empty?).to be_truthy
  end

  it 'should push one card to empty hand' do
    hand = Blackjack::Hand.new(player)
    expect(hand.empty?).to be_truthy
    hand.push(jack_of_clubs)
    expect(hand.empty?).to be_falsey
  end

  it 'should pop one card from hand' do
    hand = Blackjack::Hand.new(player)
    hand.push(jack_of_clubs)
    expect(hand.empty?).to be_falsey
    expect(hand.pop).to eq jack_of_clubs
    expect(hand.empty?).to be_truthy
  end

  it 'should flush hand' do
    hand = Blackjack::Hand.new(player)
    hand.push(jack_of_clubs)
    expect(hand.empty?).to be_falsey
    hand.flush
    expect(hand.empty?).to be_truthy
  end

  it 'should return cards collection copy' do
    hand = Blackjack::Hand.new(player)
    hand.push(jack_of_clubs)
    cards = hand.cards
    cards.push(jack_of_clubs)
    expect(hand.cards).not_to eq cards
  end

  it 'should be blackjack' do
    hand = Blackjack::Hand.new(player)
    hand.push(jack_of_clubs)
    hand.push(ace_of_spades)
    expect(hand.blackjack?).to be_truthy
  end

  it 'should be bust' do
    hand = Blackjack::Hand.new(player)
    hand.push(jack_of_clubs)
    hand.push(jack_of_clubs)
    hand.push(jack_of_clubs)
    expect(hand.bust?).to be_truthy
  end

  it 'should have 12 points for one jack and two aces' do
    hand = Blackjack::Hand.new(player)
    hand.push(ace_of_spades)
    hand.push(jack_of_clubs)
    hand.push(ace_of_spades)
    expect(hand.points).to eq 12
  end

  it 'should have 21 points for one ace and two jacks' do
    hand = Blackjack::Hand.new(player)
    hand.push(ace_of_spades)
    hand.push(jack_of_clubs)
    hand.push(jack_of_clubs)
    expect(hand.twenty_one?).to be_truthy
  end
end
