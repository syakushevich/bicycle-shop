class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :type, null: false
      t.references :catalog, foreign_key: { to_table: :products }
      t.timestamps
    end
  end
end
