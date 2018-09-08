# frozen_string_literal: true

module Blackjack
  class Console
    def self.print_logo
      logo = <<~LOGO
        ===========================================================================
        888888b.   888                   888         d8b                   888
        888  "88b  888                   888         Y8P                   888
        888  .88P  888                   888                               888
        8888888K.  888  8888b.   .d8888b 888  888   8888  8888b.   .d8888b 888  888
        888  "Y88b 888     "88b d88P"    888 .88P   "888     "88b d88P"    888 .88P
        888    888 888 .d888888 888      888888K     888 .d888888 888      888888K
        888   d88P 888 888  888 Y88b.    888 "88b    888 888  888 Y88b.    888 "88b
        8888888P"  888 "Y888888  "Y8888P 888  888    888 "Y888888  "Y8888P 888  888
        ============================================ 888 ==========================
                                                    d88P
                                                  888P"
      LOGO
      puts logo
    end

    def self.new_line
      puts
    end

    def self.print_message(message)
      puts message
    end

    def self.print_bordered_message(message, length: message.length, align: align)
      block_message = format_messages(messages: [message], length: length, align: align)
      print_horizontal([block_message])
    end

    def self.print_errors(errors)
      errors.map do |error|
        print_bordered_message("Error: #{error.message}", length: 69, align: :ljust)
      end
    end

    def self.print_game_board
      clear_screen
      print_logo
      new_line
    end

    def self.print_current_state(game)
      round_text = [
        "Round ##{game.round_number}",
        "Current bet: #{game.round.total_bet}"
      ]
      round_info = format_messages(messages: round_text, length: 32)

      player_text = [
        "Player name: #{game.player.name}",
        "Player money: #{game.player.total_money}"
      ]
      player_info = format_messages(messages: player_text, length: 32)

      print_horizontal([round_info, player_info])
    end

    def self.print_cards_state(game)
      dealer_cards_message = "Dealer's cards [points: #{game.round.dealer_points}]:"
      dealer_cards_info = format_messages(messages: [dealer_cards_message], length: 69)

      print_horizontal([dealer_cards_info])
      print_cards(game.round.dealer_cards)

      player_cards_message = "Your cards [points: #{game.round.player_points}]:"
      player_cards_info = format_messages(messages: [player_cards_message], length: 69)

      print_horizontal([player_cards_info])
      print_cards(game.round.player_cards)
    end

    def self.print_result(game)
      result_message = "#{game.round.status.capitalize}"
      result_info = format_messages(messages: [result_message], length: 69, align: :center)

      print_horizontal([result_info])

      bets_message = "Your bets: #{game.round.total_bet}"
      bets_info = format_messages(messages: [bets_message], length: 32)

      winning_message = "Your winning: #{game.round.winning}"
      winning_info = format_messages(messages: [winning_message], length: 32)

      print_horizontal([bets_info, winning_info])
    end

    def self.print_cards(cards)
      formatted_cards = cards.map { |card| format_card(card) }
      print_horizontal(formatted_cards)
    end

    def self.print_horizontal(items)
      lines_count = items.map(&:count).max
      line_idents = [''] * lines_count
      lines = items.reduce(line_idents) do |result, item|
        result.zip(item).map { |line_parts| line_parts.join(' ') }
      end
      puts lines
    end

    def self.format_messages(messages: messages, length: 0, align: :ljust)
      max_length = messages.map(&:length).max
      length = max_length if length < max_length
      formatted_messages = messages.map { |message| "│ #{message.send(align, *[length, ' '])} │" }
      lines = [
        "┌#{'─' * (length + 2)}┐",
        formatted_messages,
        "└#{'─' * (length + 2)}┘"
      ]
      lines.flatten
    end

    def self.format_card(card)
      name_to_symbol = { spades: '♠', diamonds: '♦', hearts: '♥', clubs: '♣' }
      suit = name_to_symbol[card.suit]

      literal = card.literal
      card_is_ten = literal == '10'

      top_literal = card_is_ten ? literal : "#{literal} "
      bottom_literal = card_is_ten ? literal : " #{literal}"

      [
        '┌───────┐',
        "│ #{top_literal}    │",
        '│       │',
        "│   #{suit}   │",
        '│       │',
        "│    #{bottom_literal} │",
        '└───────┘'
      ]
    end

    def self.clear_screen
      system('clear')
    end
  end
end
