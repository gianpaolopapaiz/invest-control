class Portfolio < ApplicationRecord
    has_many :portfolio_funds
    has_many :funds, through: :portfolio_funds
    has_many :portfolio_stocks
    has_many :stocks, through: :portfolio_stocks
end
