class CreateImgSignals < ActiveRecord::Migration[5.2]
  def change
    create_table :img_signals do |t|

      t.timestamps
    end
  end
end
