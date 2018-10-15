class ChangeColumnValueFromIntegerToFloat < ActiveRecord::Migration[5.2]
  def change
    change_column :transactions, :value, :float
  end
end
