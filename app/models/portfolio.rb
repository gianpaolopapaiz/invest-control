class Portfolio < ApplicationRecord
  has_many :funds
  has_many :stocks
end
