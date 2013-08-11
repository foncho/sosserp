class Item < ActiveRecord::Base
  has_many :item_products
  has_many :products, through: :item_products
  
  attr_accessible :price, :title
end
