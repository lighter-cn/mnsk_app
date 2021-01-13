class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.references :user    ,null: false, foreign_key: true
      t.references :service ,null: false, foreign_key: true
      t.text :subscription  ,null: false
      t.boolean :good       ,null: false, default: false
      t.boolean :bad        ,null: false, default: false
      t.timestamps
    end
  end
end
