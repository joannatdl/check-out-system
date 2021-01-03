require 'yaml'
require 'json'
require 'minitest/autorun'
require_relative '../lib/promotional_rules/final_price_threshold_percent_discount.rb'
require_relative '../lib/promotional_rules/product_price_breaks.rb'
require_relative '../lib/checkout.rb'
require_relative '../lib/product.rb'

describe Checkout do
  before do
    @promotional_rules = [ProductPriceBreaks.new('001', { 2 => 8.50 }),
                         FinalPriceThresholdPercentDiscount.new(60, 0.1)]
    @checkout = Checkout.new(@promotional_rules)
  end

  describe 'readme example' do
    it 'test 1' do
      scan_basket %w[001 002 003]
      assert_equal 66.78, @checkout.total
    end

    it 'test 2' do
      scan_basket %w[001 003 001]
      assert_equal 36.95, @checkout.total
    end

    it 'test 3' do
      scan_basket %w[001 002 001 003]
      assert_equal 73.76, @checkout.total
    end
  end

  it 'scanning order doesnt matter' do
    scan_basket %w[001 002 001 003]
    first_scan_total = @checkout.total
    @checkout.instance_variable_set(:@products, [])
    scan_basket %w[003 001 001 002]
    assert_equal @checkout.total, first_scan_total
  end

  it 'rules order matters' do
    scan_basket %w[001 002 001 003]
    first_scan_total = @checkout.total
    @checkout = Checkout.new(@promotional_rules.reverse)
    scan_basket %w[003 001 001 002]
    assert @checkout.total != first_scan_total
  end

  describe 'no promotional rules given' do
    before { @checkout = Checkout.new([]) }

    it 'returns original price sum' do
      scan_basket %w[001 002 001 003]
      assert_equal @checkout.instance_variable_get(:@products).sum(&:original_price), @checkout.total
    end
  end

  describe 'no products given' do
    it 'returns 0' do
      assert_equal @checkout.total, 0
    end
  end
end

def scan_basket basket
  basket.each { |basket_product_code| @checkout.scan(mapped_products[basket_product_code]) }
end

def mapped_products
  @mapped_products ||= Hash[available_products.map(&:product_code).zip(available_products)]
end

def available_products
  JSON.parse(YAML::load(File.open('available_products.yml')).to_json, object_class: Product)
end
