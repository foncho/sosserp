class CreateEstimates < ActiveRecord::Migration
  def change
    create_table :estimates do |t|
      t.integer :client_id, null: false
      t.date :delivery_date, default: Date.today
      t.date :expiration_date, default: Date.today + 30.days
      t.integer :tax_id, default: Tax.first
      t.text :observations, null: true

      t.timestamps
    end
    
    add_index :estimates, :client_id
    add_index :estimates, :tax_id
    add_index :estimates, :delivery_date
    add_index :estimates, :expiration_date
  end
end
