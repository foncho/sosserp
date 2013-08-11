class CreateRates < ActiveRecord::Migration
  def change
    remove_column :invoices, :tax_id
    
    create_table :rates do |t|
      t.integer :invoice_id
      t.integer :tax_id, default: Tax.first

      t.timestamps
    end
    
    add_index :rates, :invoice_id
    add_index :rates, :tax_id
  end
end
