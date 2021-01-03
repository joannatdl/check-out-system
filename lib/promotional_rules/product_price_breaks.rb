# When purchasing 2 or more of the Red Scarf, its price is reduced to £8.50.

class ProductPriceBreaks

  def initialize product_code, price_breaks
    @product_code = product_code
    @price_breaks = price_breaks # eg. { 2: 8.50 }
  end

  def reduce_prices products
    counted_products = products.map(&:product_code).tally
    products.each do |product|
      count = counted_products[product.product_code]
      product.reduced_price = reduced_price(count) if code_matches(product)
    end
  end

  private

  def code_matches product
    @product_code == product.product_code
  end

  def reduced_price count
    threshold = @price_breaks.keys.sort.reverse.detect{ |threshold| count - threshold >= 0 }
    @price_breaks[threshold]
  end
end
