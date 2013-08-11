# encoding: UTF-8

class PaymentMethod < ActiveRecord::Base
  has_many :invoices
  
  attr_accessible :name
end
