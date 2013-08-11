# encoding: UTF-8

class LineItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :estimate
  belongs_to :invoice, touch: true
  
  attr_accessible :id, :product_id, :estimate_id, :invoice_id, :quantity
  
  attr_accessor :product_name
  
  def product_name=(token)
    self.product_id = Product.id_from_token(token)
  end
  
  def product_name
    product.name unless product.nil?
  end
  
  def discount_calculation
    t = estimate_id.nil? ? invoice : estimate
    client = t.client if t.client
    #product.nil? ? 0 : (product.prices.last.value * (discount.to_f / 100))
    product.nil? ? 0 : (product.items.sum(:price) * ((client.nil? or client.discount.nil?) ? 0 : (client.discount.value.to_f / 100)))
  end
  
  def tax_calculation
    t = estimate_id.nil? ? invoice : estimate
    if t == invoice
      product.nil? ? 0 : ((product.items.sum(:price) - discount_calculation) * (t.taxes.empty? ? 0 : (t.taxes.first.value.to_f / 100)))
    else
      product.nil? ? 0 : ((product.items.sum(:price) - discount_calculation) * (t.tax.nil? ? 0 : (t.tax.value.to_f / 100)))
    end
  end
  
  def irpf_calculation
    if invoice
      taxes = invoice.taxes.sort_by{ |i| i.name }
      product.nil? ? 0 : ((product.items.sum(:price) - discount_calculation) * (invoice.taxes.count > 1 ? (taxes.last.value.to_f / 100) : 0))
    else
      0
    end
  end
    
  def subtotal
    t = estimate_id.nil? ? invoice : estimate
    product.nil? ? 0 : ((product.items.sum(:price) - discount_calculation) * quantity)
  end
  
  def total_price
    t = estimate_id.nil? ? invoice : estimate
    product.nil? ? 0 : ((product.items.sum(:price) - discount_calculation + tax_calculation + irpf_calculation) * quantity)
  end
end
