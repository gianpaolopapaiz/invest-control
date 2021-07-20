class CreateCdis < ActiveRecord::Migration[6.0]
  def change
    create_table :cdis do |t|
      t.float :value_month
      t.float :value_day
      t.date :date

      t.timestamps
    end
  end
end
