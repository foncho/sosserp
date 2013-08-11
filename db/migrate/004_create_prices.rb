class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.integer :product_id
      t.float :value, default: 0

      t.timestamps
    end
    
    add_index :prices, :product_id
    add_index :prices, :value
  end
end
