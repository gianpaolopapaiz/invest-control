class ChangeQuantityFromStock < ActiveRecord::Migration[6.0]
  def change
    change_column :stocks, :buy_quantity, :float
  end
end
