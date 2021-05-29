class CreateFunds < ActiveRecord::Migration[6.0]
  def change
    create_table :funds do |t|
      t.string :short_name
      t.string :cnpj
      t.string :class
      t.string :performance_text
      t.date :buy_date
      t.integer :buy_quantity
      t.float :buy_price
      t.string :strategy

      t.timestamps
    end
  end
end
