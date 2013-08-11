class Rate < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :tax
  
  attr_accessible :invoice_id, :tax_id
end
