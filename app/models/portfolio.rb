class Portfolio < ApplicationRecord
  belongs_to :stock
  belongs_to :fund
  validates :name, presence: true, uniqueness: true
end
