class DropPortfolioFundsTable < ActiveRecord::Migration[6.0]
  def up
    drop_table :portfolio_funds
  end
end
