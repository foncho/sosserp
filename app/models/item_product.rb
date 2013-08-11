class ItemProduct < ActiveRecord::Base
  belongs_to :item
  belongs_to :product
  
  attr_accessible :item_id, :product_id
end
