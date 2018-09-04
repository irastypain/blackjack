# frozen_string_literal: true

require 'blackjack/card'

describe Blackjack::Card do
  it 'should make the jack of hearts card' do
    jack_of_hearts = Blackjack::Card.new('J', :hearts)
    expect(jack_of_hearts.literal).to eq 'J'
    expect(jack_of_hearts.suit).to eq :hearts
  end

  it 'should raise an error if make card with unsupported literal' do
    expect { Blackjack::Card.new('1', :hearts) }.to raise_error RuntimeError
  end

  it 'should raise an error if make card with unsupported suit' do
    expect { Blackjack::Card.new('Q', :smiles) }.to raise_error RuntimeError
  end

  it 'should return 11 points for ace' do
    ace = Blackjack::Card.new('A', :spades)
    expect(ace.points).to eq 11
  end

  it 'should return 10 points for ten/jack/queen/king card' do
    literals = %w[10 J Q K]
    cards = literals.map { |literal| Blackjack::Card.new(literal, :hearts) }

    cards.each do |card|
      expect(card.points).to eq 10
    end
  end

  it 'should return up 2 to 9 points for simple cards' do
    literals = %w[2 3 4 5 6 7 8 9]
    cards = literals.map { |literal| Blackjack::Card.new(literal, :clubs) }

    cards.each do |card|
      expect(card.points).to eq card.literal.to_i
    end
  end
end
