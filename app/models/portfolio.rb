class Portfolio < ApplicationRecord
  belongs_to :user
  has_many :funds
  has_many :stocks
end
