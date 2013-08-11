class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :client_id, null: false
      t.date :expiration_date, null: false, default: Date.today + 7.days
      t.integer :tax_id, default: Tax.first
      t.integer :payment_method_id, default: PaymentMethod.first
      t.string :status, default: Invoice::STATUS.first
      t.text :observations

      t.timestamps
    end
    
    add_index :invoices, :client_id
    add_index :invoices, :tax_id
    add_index :invoices, :payment_method_id
    add_index :invoices, :status
  end
end
