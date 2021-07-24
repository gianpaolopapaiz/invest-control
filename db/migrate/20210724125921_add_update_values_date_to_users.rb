class AddUpdateValuesDateToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :update_values_date, :date, default: Date.new(20210, 1, 1)
  end
end
