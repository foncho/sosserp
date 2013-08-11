class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :estimate_id
      t.text :description, null: false, default: ""
      t.integer :estimation_time_in_days, default: 30

      t.timestamps
    end
  end
end
