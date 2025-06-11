class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.string :sku
      t.decimal :price
      t.string :supplier_id
      t.string :supplier_type
      t.boolean :active

      t.timestamps
    end
  end
end
