class CreateStocks < ActiveRecord::Migration[6.0]
  def change
    create_table :stocks do |t|
      t.string :short_name
      t.string :symbol
      t.string :strategy
      t.date :buy_date
      t.integer :buy_quantity
      t.float :buy_price

      t.timestamps
    end
  end
end
