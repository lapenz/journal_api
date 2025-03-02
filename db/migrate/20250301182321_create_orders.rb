class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.datetime :ordered_at
      t.decimal :price_per_item
      t.integer :quantity
      t.decimal :shipping
      t.decimal :tax_rate

      t.timestamps
    end
  end
end
