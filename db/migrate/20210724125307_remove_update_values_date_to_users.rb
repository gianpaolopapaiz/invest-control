class RemoveUpdateValuesDateToUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :update_values_date
  end
end
