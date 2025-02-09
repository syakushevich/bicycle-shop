class CreateParts < ActiveRecord::Migration[7.1]
  def change
    create_table :parts do |t|
      t.references :product, null: false, foreign_key: true
      t.string :part_key
      t.timestamps
    end
  end
end
