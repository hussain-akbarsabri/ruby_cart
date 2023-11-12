# frozen_string_literal: true

require_relative '../modules/store'
require_relative '../modules/console_display'

RSpec.describe Store do
  let(:store) { Store.new }

  describe '#add_to_cart' do
    it 'adds a product to the cart when the product code is valid' do
      expect(store.add_to_cart('GR1')).to eq('Product added successfully')
    end

    it 'returns "Product not found" when the product code is invalid' do
      expect(store.add_to_cart('InvalidCode')).to eq('Product not found')
    end
  end

  describe '#display_cart' do
    it 'displays cart contents' do
      store.add_to_cart('GR1')
      store.add_to_cart('SR1')
      expect { store.display_cart }.to output(
        <<~EXPECTED_OUTPUT
          | Cart | Total price expected |
          |--|--|
          | GR1,SR1 | 8.11€ |
        EXPECTED_OUTPUT
      ).to_stdout
    end
  end

  describe '#calculate_bill' do
    it "displays cart's bill equal to 3.11" do
      store.add_to_cart('GR1')
      store.add_to_cart('GR1')
      expect { store.display_cart }.to output(
        <<~EXPECTED_OUTPUT
          | Cart | Total price expected |
          |--|--|
          | GR1,GR1 | 3.11€ |
        EXPECTED_OUTPUT
      ).to_stdout
    end

    it "displays cart's bill equal to 16.61" do
      store.add_to_cart('SR1')
      store.add_to_cart('SR1')
      store.add_to_cart('GR1')
      store.add_to_cart('SR1')
      expect { store.display_cart }.to output(
        <<~EXPECTED_OUTPUT
          | Cart | Total price expected |
          |--|--|
          | SR1,SR1,GR1,SR1 | 16.61€ |
        EXPECTED_OUTPUT
      ).to_stdout
    end

    it "displays cart's bill equal to 30.57" do
      store.add_to_cart('GR1')
      store.add_to_cart('CF1')
      store.add_to_cart('SR1')
      store.add_to_cart('CF1')
      store.add_to_cart('CF1')
      expect { store.display_cart }.to output(
        <<~EXPECTED_OUTPUT
          | Cart | Total price expected |
          |--|--|
          | GR1,CF1,SR1,CF1,CF1 | 30.57€ |
        EXPECTED_OUTPUT
      ).to_stdout
    end
  end
end

RSpec.describe ConsoleDisplay do
  describe '.display_products' do
    it 'should display products' do
      products = [
        { 'product_code' => 'GR1', 'name' => 'Green Tea', 'price' => 3.11 },
        { 'product_code' => 'SR1', 'name' => 'Strawberries', 'price' => 5.0 },
        { 'product_code' => 'CF1', 'name' => 'Coffee', 'price' => 11.23 }
      ]
      expect { ConsoleDisplay.display_products(products) }.to output(
        <<~OUTPUT
          | Product Code | Name | Price |
          |--|--|--|
          | GR1 | Green Tea | 3.11€ |
          | SR1 | Strawberries | 5.0€ |
          | CF1 | Coffee | 11.23€ |
        OUTPUT
      ).to_stdout
    end
  end
end
