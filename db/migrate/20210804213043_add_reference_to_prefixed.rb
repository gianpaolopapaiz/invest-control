class AddReferenceToPrefixed < ActiveRecord::Migration[6.0]
  def change
    add_reference :prefixeds, :portfolio, null: false, foreign_key: true
  end
end
