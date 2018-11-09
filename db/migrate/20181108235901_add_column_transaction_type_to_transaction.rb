class AddColumnTransactionTypeToTransaction < ActiveRecord::Migration[5.2]
  def change
    # add_column (model, coluna a adicionar, tipo)
    add_column :transactions, :is_debt, :boolean
  end
end
