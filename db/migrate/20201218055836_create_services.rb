class CreateServices < ActiveRecord::Migration[6.0]
  def change
    create_table :services do |t|
      t.string :service_name,   null: false
      t.integer :price,         null: false
      t.text :explanation,      null: false
      t.string :service_status, null: false
      t.string :service_id,     null: false
      t.integer :category_id,   null: false
      t.references :user,       null: false, foreign_key: true
      t.timestamps
    end
  end
end
