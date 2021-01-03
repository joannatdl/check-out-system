Product = Struct.new(:product_code, :name, :original_price, :reduced_price) do
  def price
    reduced_price || original_price
  end
end
