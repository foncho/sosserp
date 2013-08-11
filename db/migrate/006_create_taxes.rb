class CreateTaxes < ActiveRecord::Migration
  def change
    create_table :taxes do |t|
      t.string :name
      t.integer :value

      t.timestamps
    end
    
    add_index :taxes, :name
    add_index :taxes, :value
  end
end
