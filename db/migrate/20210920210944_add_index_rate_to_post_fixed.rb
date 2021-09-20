class AddIndexRateToPostFixed < ActiveRecord::Migration[6.0]
  def change
    add_column :post_fixeds, :rate_index, :float
  end
end
