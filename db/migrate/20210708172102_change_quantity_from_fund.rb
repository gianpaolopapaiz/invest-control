class ChangeQuantityFromFund < ActiveRecord::Migration[6.0]
  def change
    change_column :funds, :buy_quantity, :float
  end
end
