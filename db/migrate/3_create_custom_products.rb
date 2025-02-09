class CreateCustomProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :custom_products do |t|
      t.string :name, null: false
      t.string :type, null: false
      t.references :catalog_product, foreign_key: { to_table: :products }
      t.timestamps
    end
  end
end
