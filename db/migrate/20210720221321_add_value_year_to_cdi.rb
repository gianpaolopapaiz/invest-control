class AddValueYearToCdi < ActiveRecord::Migration[6.0]
  def change
    add_column :cdis, :value_year, :float
  end
end
