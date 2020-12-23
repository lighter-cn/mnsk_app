class CreateCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :codes do |t|
      t.string :code,      null: false
      t.string :status,    null: false
      t.references :order, null: false, foreign_key: true
      t.timestamps
    end
  end
end
