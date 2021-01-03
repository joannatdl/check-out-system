# When spending over £60, the customer gets 10% off their purchase

class FinalPriceThresholdPercentDiscount

  def initialize threshold, percent_discount
    @threshold = threshold
    @percent_discount = percent_discount
  end

  def reduce_prices products
    return products if products.map(&:price).sum <= @threshold

    products.each do |product|
      product.reduced_price = product.price * (1 - @percent_discount)
    end
  end
end
