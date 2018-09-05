# frozen_string_literal: true

require 'blackjack/dealer'

describe Blackjack::Dealer do
  it 'should make a dealer' do
    dealer = Blackjack::Dealer.new('Smith')
    expect(dealer.name).to eq 'Smith'
  end
end
