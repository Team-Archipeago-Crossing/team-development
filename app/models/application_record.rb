class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  $tax_rate = 1.08
  
  def price_taxin
    price = (self.price * $tax_rate).floor
    "￥ #{price.to_s(:delimited)}"
  end
  
  def price_taxout
    price = self.price
    "￥ #{price.to_s(:delimited)}"
  end
end
