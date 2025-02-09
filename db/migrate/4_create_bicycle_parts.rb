class CreateBicycleParts < ActiveRecord::Migration[7.1]
  def change
    create_table :bicycle_parts do |t|
      t.references :bicycle, null: false, foreign_key: true
      t.references :part, null: false, foreign_key: true
      t.references :part_option, null: false, foreign_key: true
      t.timestamps
    end
  end
end
