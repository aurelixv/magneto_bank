class ChangeColumnTypes < ActiveRecord::Migration[5.2]
  def change
    change_column :cards, :balance, :float
    change_column :clients, :balance, :float
  end
end
