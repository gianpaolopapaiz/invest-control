class AddDateTaxToCdi < ActiveRecord::Migration[6.0]
  def change
    add_column :cdis, :date_tax, :date
  end
end
