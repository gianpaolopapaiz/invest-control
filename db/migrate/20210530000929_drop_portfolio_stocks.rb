class DropPortfolioStocks < ActiveRecord::Migration[6.0]
  def change
    def up
      drop_table :portfolio_stocks
    end
  
    def down
      raise ActiveRecord::IrreversibleMigration
    end
  end
end
