class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer :estimate_id
      t.integer :invoice_id
      t.integer :product_id
      t.integer :quantity, default: 1

      t.timestamps
    end
    
    add_index :line_items, :estimate_id
    add_index :line_items, :invoice_id
    add_index :line_items, :product_id
    add_index :line_items, :quantity
  end
end
