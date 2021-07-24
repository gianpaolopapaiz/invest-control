class AddUpdateValuesDateAgainToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :update_values_date, :date, default: Date.new(2010, 1, 1)
  end
end
