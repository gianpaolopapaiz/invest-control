class DropPortfolioStocksTable < ActiveRecord::Migration[6.0]
  def up
    drop_table :portfolio_stocks
  end
end
