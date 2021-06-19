class AddAdvisorToFunds < ActiveRecord::Migration[6.0]
  def change
    add_column :funds, :advisor, :string
  end
end
