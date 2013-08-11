class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :code, null: false, default: ""
      t.string :name, null: false, default: ""
      t.string :cif
      t.string :contact
      t.text :address
      t.string :city
      t.string :province
      t.string :postcode
      t.string :country
      t.string :phone, limit: 18
      t.string :fax
      t.string :email
      t.text :observations

      t.timestamps
    end
  end
end
