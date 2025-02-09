class CreateCustomProductParts < ActiveRecord::Migration[7.1]
  def change
    create_table :custom_product_parts do |t|
      t.references :custom_product, null: false, foreign_key: true
      t.references :part, null: false, foreign_key: true
      t.references :part_option, null: false, foreign_key: true
      t.timestamps
    end
  end
end
