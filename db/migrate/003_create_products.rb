class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :code, limit: 8
      
      t.string :name, null: false, default: ""
      t.text :description, default: ""

      t.timestamps
    end

    add_index :products, :code, unique: true
    add_index :products, :name
  end
end
