class AddNumberToInvoicesAndEstimates < ActiveRecord::Migration
  def change
    add_column :invoices, :number, :integer, null: false, default: (Invoice.any? ? Invoice.last.id : 1)
    add_column :estimates, :number, :integer, null: false, default: (Estimate.any? ? Estimate.last.id : 1)
    
    add_index :invoices, :number, unique: true
    add_index :estimates, :number, unique: true
  end
end
