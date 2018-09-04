# frozen_string_literal: true

require 'blackjack/deck'

describe Blackjack::Deck do
  it 'should make a deck which has 52 cards' do
    deck = Blackjack::Deck.new
    expect(deck.cards.count).to eq 52
  end
end
