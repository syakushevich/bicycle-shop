class CreateBicycles < ActiveRecord::Migration[7.1]
  def change
    create_table :bicycles do |t|
      t.string :name, null: false
      t.references :catalog, foreign_key: { to_table: :products }
      t.timestamps
    end
  end
end
