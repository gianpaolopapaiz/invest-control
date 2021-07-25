class CreateIpcas < ActiveRecord::Migration[6.0]
  def change
    create_table :ipcas do |t|
      t.float :value_month
      t.float :value_day
      t.float :value_year
      t.date :date_tax
      t.date :date_update

      t.timestamps
    end
  end
end
