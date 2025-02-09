class CreatePartOptions < ActiveRecord::Migration[7.1]
  def change
    create_table :part_options do |t|
      t.references :part, null: false, foreign_key: true
      t.string :option
      t.boolean :in_stock, default: true
      t.timestamps
    end
  end
end
