class AddPortfolioToStock < ActiveRecord::Migration[6.0]
  def change
    add_reference :stocks, :portfolio, null: false, foreign_key: true
  end
end
