# frozen_string_literal: true

require_relative 'modules/store'
require_relative 'modules/console_display'

ConsoleDisplay.clear_screen

@store = Store.new

def valid_option_selected(option)
  return true if (1..4).include?(option)

  ConsoleDisplay.wrong_input_message
  ConsoleDisplay.go_back_message
  gets.chomp
  ConsoleDisplay.clear_screen
end

loop do
  ConsoleDisplay.options_menu

  selected_option = gets.chomp.to_i

  next unless valid_option_selected(selected_option)

  case selected_option
  when 1
    @store.display_products
    ConsoleDisplay.go_back_message
    gets.chomp
  when 2
    @store.display_cart
    ConsoleDisplay.go_back_message
    gets.chomp
  when 3
    loop do
      @store.display_products
      ConsoleDisplay.input_product_code_message
      ConsoleDisplay.cart_response_message(@store.add_to_cart(gets.chomp))
      ConsoleDisplay.add_another_product_message
      break unless gets.chomp.downcase == 'y'
    end
  when 4
    ConsoleDisplay.exit_message
    break
  end
  ConsoleDisplay.clear_screen
end
