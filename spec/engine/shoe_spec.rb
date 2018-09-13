# frozen_string_literal: true

describe Blackjack::Shoe do
  it 'should make a shoe with one deck' do
    shoe = Blackjack::Shoe.new(Blackjack::Deck.new, 1)
    expect(shoe.empty?).to be_falsey
    dequeued_cards = []
    until shoe.empty?
      dequeued_cards << shoe.dequeue
    end
    expect(dequeued_cards.count).to eq 52
  end

  it 'should shuffle shoe' do
    shoe = Blackjack::Shoe.new(Blackjack::Deck.new, 1)
    original_shoe = shoe.clone
    expect(shoe.shuffle!).not_to eq original_shoe
  end
end
