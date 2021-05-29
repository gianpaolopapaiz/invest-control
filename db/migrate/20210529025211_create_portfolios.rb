class CreatePortfolios < ActiveRecord::Migration[6.0]
  def change
    create_table :portfolios do |t|
      t.string :name
      t.references :stock, null: false, foreign_key: true
      t.references :fund, null: false, foreign_key: true

      t.timestamps
    end
  end
end
