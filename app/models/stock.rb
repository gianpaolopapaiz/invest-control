class Stock < ApplicationRecord
  has_many :portfolio_stocks
  has_many :portfolios, through: :portfolio_stocks
  STRATEGIES = ['post-fixed', 'pre-fixed', 'inflation', 'multimarket', 'variable', 'international']
  validates :short_name, :symbol, :strategy, :buy_date, :buy_quantity, :buy_price, presence: true
	validates :short_name, :symbol, uniqueness: true
	validates :strategy, inclusion: { in: STRATEGIES }
end
