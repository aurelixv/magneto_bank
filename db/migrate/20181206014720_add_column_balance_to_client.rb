class AddColumnBalanceToClient < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :balance, :bigint
  end
end
