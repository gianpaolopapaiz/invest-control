class AddCnpjCleanToFunds < ActiveRecord::Migration[6.0]
  def change
    add_column :funds, :cnpj_clean, :string
  end
end
