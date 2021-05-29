class PortfolioFund < ApplicationRecord
  belongs_to :portfolio
  belongs_to :fund
end
