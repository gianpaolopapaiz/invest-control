class Portfolio < ApplicationRecord
  belongs_to :stock
  belongs_to :fund
end
