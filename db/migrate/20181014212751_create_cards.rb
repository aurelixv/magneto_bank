class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.boolean :card_type
      t.bigint :card_number
      t.integer :verification_number
      t.date :aquisition_date
      t.date :due_date

      t.timestamps
    end
  end
end
