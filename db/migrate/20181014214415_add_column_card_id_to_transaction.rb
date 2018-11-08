class AddColumnCardIdToTransaction < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :card_id, :integer
    add_foreign_key :transactions, :cards
  end
end
