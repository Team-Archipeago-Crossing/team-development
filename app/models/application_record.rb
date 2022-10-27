class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  $tax_rate = 1.08
end