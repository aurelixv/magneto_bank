class AddIndexDateToTransaction < ActiveRecord::Migration[5.2]
  def change
    add_index :transactions, :transaction_date
  end
end
