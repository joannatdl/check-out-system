# co = Checkout.new(promotional_rules)
# co.scan(item)
# co.scan(item)
# price = co.total

class Checkout
  def initialize promotional_rules
    @promotional_rules = promotional_rules
    @products = []
  end

  def scan product
    @products << product
  end

  def total
    products_dup = @products.map(&:dup)
    @promotional_rules.each { |pr| pr.reduce_prices(products_dup) }
    products_dup.sum(&:price).round(2)
  end
end
