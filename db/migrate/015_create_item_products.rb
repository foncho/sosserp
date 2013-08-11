class CreateItemProducts < ActiveRecord::Migration
  def change
    create_table :item_products do |t|
      t.integer :item_id
      t.integer :product_id

      t.timestamps
    end
  end
end
