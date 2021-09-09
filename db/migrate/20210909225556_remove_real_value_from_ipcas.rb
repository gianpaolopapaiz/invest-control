class RemoveRealValueFromIpcas < ActiveRecord::Migration[6.0]
  def change
    remove_column :ipcas, :real_value
  end
end
