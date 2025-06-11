class CreateCustomizations < ActiveRecord::Migration[7.2]
  def change
    create_table :customizations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.text :design_data
      t.text :ai_estimation
      t.string :status

      t.timestamps
    end
  end
end
