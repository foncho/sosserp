class CreatePaymentMethods < ActiveRecord::Migration
  def change
    create_table :payment_methods do |t|
      t.string :name

      t.timestamps
    end
    
    add_index :payment_methods, :name
  end
end
