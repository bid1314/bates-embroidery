class CreateStores < ActiveRecord::Migration[7.2]
  def change
    create_table :stores do |t|
      t.string :name
      t.string :subdomain
      t.string :domain
      t.boolean :active
      t.text :settings

      t.timestamps
    end
  end
end
