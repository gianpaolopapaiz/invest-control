class AddColumnsToFunds < ActiveRecord::Migration[6.0]
  def change
    add_column :funds, :actual_price, :float
    add_column :funds, :actual_date, :date
  end
end
