class ChangeColumnCardIdFromIntegerToString < ActiveRecord::Migration[5.2]
  def change
    change_column :cards, :card_number, :string
  end
end
