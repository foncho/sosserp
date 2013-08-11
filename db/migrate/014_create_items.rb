class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.float :price, default: 0

      t.timestamps
    end
  end
end
