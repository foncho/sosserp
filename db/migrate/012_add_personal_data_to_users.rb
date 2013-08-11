class AddPersonalDataToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string, null: false, default: ""
    add_column :users, :surname, :string, null: false, default: ""
    add_column :users, :pid, :string
    add_column :users, :phone, :string
    add_column :users, :address, :text
    add_column :users, :observations, :text
  end
end
