# encoding: UTF-8

class Discount < ActiveRecord::Base
  belongs_to :client
  
  attr_accessible :client_id, :value
end
