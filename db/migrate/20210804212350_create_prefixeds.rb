class CreatePrefixeds < ActiveRecord::Migration[6.0]
  def change
    create_table :prefixeds do |t|
      t.string :short_name
      t.string :description
      t.string :strategy
      t.date :buy_date
      t.float :buy_quantity
      t.float :buy_price
      t.float :actual_price
      t.date :actual_date
      t.string :advisor
      t.float :year_tax
      t.date :end_date

      t.timestamps
    end
  end
end
