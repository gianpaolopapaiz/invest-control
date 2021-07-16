class AddUpdateValuesDateToPortfolio < ActiveRecord::Migration[6.0]
  def change
    add_column :portfolios, :update_values_date, :date
  end
end
