class ChangeClassOfFunds < ActiveRecord::Migration[6.0]
  def change
    rename_column :funds, :class, :fund_class
  end
end
