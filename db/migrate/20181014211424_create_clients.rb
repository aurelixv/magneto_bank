class CreateClients < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :email
      t.string :address
      t.integer :zip_code
      t.string :password
      t.bigint :ssid
      t.date :birth_date

      t.timestamps
    end
  end
end
