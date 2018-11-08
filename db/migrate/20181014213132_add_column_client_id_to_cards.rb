class AddColumnClientIdToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :client_id, :integer
    add_foreign_key :cards, :clients
  end
end
