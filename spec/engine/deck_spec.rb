# frozen_string_literal: true

describe Blackjack::Deck do
  it 'should make a deck which has 52 cards' do
    deck = Blackjack::Deck.new
    expect(deck.cards.count).to eq 52
  end

  it 'should return cards collection copy' do
    deck = Blackjack::Deck.new
    jack_of_clubs = Blackjack::Card.new('J', :clubs)
    cards = deck.cards
    cards.push(jack_of_clubs)
    expect(deck.cards).not_to eq cards
  end
end
