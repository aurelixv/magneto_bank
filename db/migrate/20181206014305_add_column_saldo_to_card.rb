class AddColumnSaldoToCard < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :balance, :bigint
  end
end
