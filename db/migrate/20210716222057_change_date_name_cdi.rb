class ChangeDateNameCdi < ActiveRecord::Migration[6.0]
  def change
    rename_column :cdis, :date, :date_update
  end
end
