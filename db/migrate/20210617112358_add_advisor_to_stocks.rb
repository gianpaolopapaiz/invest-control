class AddAdvisorToStocks < ActiveRecord::Migration[6.0]
  def change
    add_column :stocks, :advisor, :string
  end
end
