# frozen_string_literal: true

# ConsoleDisplay
class ConsoleDisplay
  def self.clear_screen
    if Gem.win_platform?
      system('cls')
    else
      system('clear')
    end
  end

  def self.options_menu
    puts 'Please select an option'
    puts "\t 1) Show all products"
    puts "\t 2) Show cart"
    puts "\t 3) Add product to cart"
    puts "\t 4) Exit"
    puts "\n"
    print "\t Enter your option (Index No.): "
  end

  def self.wrong_input_message
    puts "\nYour selected option is invalid..."
  end

  def self.go_back_message
    print "\nPress enter to go back..."
  end

  def self.display_products(products)
    puts '| Product Code | Name | Price |'
    puts '|--|--|--|'

    products.each do |product|
      code = product['product_code']
      name = product['name']
      price = "#{product['price']}€"
      puts "| #{code} | #{name} | #{price} |"
    end
  end

  def self.display_cart_products(cart, discount_price)
    puts '| Cart | Total price expected |'
    puts '|--|--|'
    puts "| #{cart.map { _1['product_code'] }.join(',')} | #{discount_price}€ |" unless cart.empty?
  end

  def self.exit_message
    puts "\nSee you again!!!"
  end

  def self.cart_response_message(message)
    puts "\n#{message}"
  end

  def self.input_product_code_message
    print "\nEnter the product code to add to the cart: "
  end

  def self.add_another_product_message
    print "\nDo you want to add another product? (YyNn): "
  end
end
