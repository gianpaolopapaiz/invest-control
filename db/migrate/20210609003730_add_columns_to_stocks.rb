class AddColumnsToStocks < ActiveRecord::Migration[6.0]
  def change
    add_column :stocks, :actual_price, :float
    add_column :stocks, :actual_date, :date
  end
end
