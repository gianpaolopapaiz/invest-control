class RemoveUpdateDateFromStocks < ActiveRecord::Migration[6.0]
  def change
    remove_column :stocks, :update_date
  end
end
