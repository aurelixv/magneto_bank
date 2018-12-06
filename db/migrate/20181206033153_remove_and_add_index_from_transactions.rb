class RemoveAndAddIndexFromTransactions < ActiveRecord::Migration[5.2]
  def change
    remove_index :transactions, :transaction_date
    add_index :transactions, [:card_id, :transaction_date]
  end
end
