class CreatePortfolioFunds < ActiveRecord::Migration[6.0]
  def change
    create_table :portfolio_funds do |t|
      t.references :portfolio, null: false, foreign_key: true
      t.references :fund, null: false, foreign_key: true

      t.timestamps
    end
  end
end
