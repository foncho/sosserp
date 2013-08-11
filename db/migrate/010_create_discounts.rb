class CreateDiscounts < ActiveRecord::Migration
  def change
    create_table :discounts do |t|
      t.integer :client_id
      t.float :value, default: 0

      t.timestamps
    end
    
    add_index :discounts, :client_id
    add_index :discounts, :value
  end
end
