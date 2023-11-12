# frozen_string_literal: true

require 'json'

# Store
class Store
  PRODUCTS_PATH = 'data/products.json'
  DISCOUNTS_PATH = 'data/discounts.json'

  def initialize
    @products = fetch_data_from_file(PRODUCTS_PATH)
    @discounts = fetch_data_from_file(DISCOUNTS_PATH)
    @cart = []
  end

  def display_products
    ConsoleDisplay.display_products(@products)
  end

  def display_cart
    ConsoleDisplay.display_cart_products(@cart, discounted_price)
  end

  def discounted_price
    @cart.group_by { |product| product['product_code'] }.sum do |product_code, products|
      apply_discount(products, product_code)
    end.round(2)
  end

  def add_to_cart(product_code)
    selected_product = @products.find { |product| product['product_code'] == product_code }
    if selected_product
      @cart << selected_product
      'Product added successfully'
    else
      'Product not found'
    end
  end

  private

  def fetch_data_from_file(file_path)
    file_data = File.read(file_path)
    JSON.parse(file_data)
  rescue StandardError
    []
  end

  def apply_discount(cart_products, product_code)
    case @discounts[product_code]['type']
    when 'buy_one_get_one'
      return buy_one_get_one_discount(cart_products, product_code)
    when 'discount_price', 'discount_percent'
      if cart_products.count >= @discounts[product_code]['threshold']
        return send("#{@discounts[product_code]['type']}_discount", cart_products,
                    product_code)
      end
    end

    cart_products[0]['price'] * cart_products.count
  end

  def buy_one_get_one_discount(cart_products, _product_code)
    ((cart_products.count / 2) + (cart_products.count % 2)) * cart_products[0]['price']
  end

  def discount_price_discount(cart_products, product_code)
    @discounts[product_code]['discount_price'] * cart_products.count
  end

  def discount_percent_discount(cart_products, _product_code)
    (cart_products[0]['price'] * 2.0 / 3.0) * cart_products.count
  end
end
