class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.string :transaction_type
      t.integer :value
      t.date :transaction_date

      t.timestamps
    end
  end
end
