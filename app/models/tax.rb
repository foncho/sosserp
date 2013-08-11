# encoding: UTF-8

class Tax < ActiveRecord::Base
  has_many :rates
  has_many :invoices, through: :rates
  has_many :delivery_notes
  has_many :expenses
  
  attr_accessible :name, :value
end
