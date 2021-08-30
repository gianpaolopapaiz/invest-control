class AddRealValueToIpcas < ActiveRecord::Migration[6.0]
  def change
    add_column :ipcas, :real_value, :boolean
  end
end
