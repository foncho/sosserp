class AddUserIdToDeliveryNotes < ActiveRecord::Migration
  def change
    add_column :estimates, :user_id, :integer
  end
end
