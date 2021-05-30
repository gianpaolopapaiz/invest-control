class AddPortfolioToFunds < ActiveRecord::Migration[6.0]
  def change
    add_reference :funds, :portfolio, null: false, foreign_key: true
  end
end
