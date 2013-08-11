# encoding: UTF-8

class Invoice < ActiveRecord::Base
  belongs_to :client
  belongs_to :payment_method
  has_many :line_items, dependent: :destroy
  has_many :products, through: :line_items
  has_many :prices, through: :products
  has_many :rates, dependent: :destroy
  has_many :taxes, through: :rates
  
  accepts_nested_attributes_for :line_items
  accepts_nested_attributes_for :rates
  
  attr_accessible :number, :client_id, :line_items_attributes, :payment_method_id, :status, :observations, :created_at,
    :total_price, :subtotal, :rates_attributes, :expiration_date
    
  attr_accessor :subtotal, :total_price
  
  validates :client_id, presence: { message: " no puede estar en blanco." }
  
  STATUS = ["Pendiente", "Pagada"]
  
  def to_param
    number
  end
  
  def self.total_items(start_date, end_date, product_id, client_id, client_type_id)
    #selected_items(start_date, end_date, product_id).to_a.sum { |item| item.quantity }
    selected_items(start_date, end_date, product_id, client_id, client_type_id)
  end
  
  def self.selected_items(start_date, end_date, product_id, client_id, client_type_id)
=begin
    LineItem.select("li.invoice_id, li.delivery_note_id, li.order_id, li.product_id, li.quantity, li.created_at")
      .joins("AS li INNER JOIN invoices AS i ON li.invoice_id = i.id")
      .joins("INNER JOIN rates AS r ON r.invoice_id = i.id")
      .joins("INNER JOIN clients AS c ON i.client_id = c.id")
      .joins("INNER JOIN client_types AS ct ON c.client_type_id = ct.id")
      .where("i.created_at BETWEEN ? AND ? AND i.client_id IN (?)", start_date, end_date, (client_id.nil? or client_id.blank?) ? ((client_type_id.nil? or client_type_id.blank?) ? Client.all : Client.find_all_by_client_type_id(client_type_id)) : client_id)
      .group("li.id, li.invoice_id, li.delivery_note_id, li.order_id, li.product_id, li.quantity, li.created_at, i.created_at")
      .where("li.product_id IN (?)", (product_id.nil? or product_id.blank?) ? Product.all : product_id)
=end
    select("i.id, i.number, i.client_id, i.payment_method_id, i.status, i.observations, i.created_at, i.expiration_date")
    .joins("AS i INNER JOIN line_items AS li ON li.invoice_id = i.id")
    .joins("INNER JOIN rates AS r ON r.invoice_id = i.id")
    .joins("INNER JOIN clients AS c ON i.client_id = c.id")
    .joins("INNER JOIN client_types AS ct ON c.client_type_id = ct.id")
    .where("i.created_at BETWEEN ? AND ? AND i.client_id IN (?)", start_date, end_date, (client_id.nil? or client_id.blank?) ? ((client_type_id.nil? or client_type_id.blank?) ? Client.all : Client.find_all_by_client_type_id(client_type_id)) : client_id)
    .group("i.id, i.number, i.client_id, i.payment_method_id, i.status, i.observations, i.created_at, i.expiration_date")
    .where("li.product_id IN (?)", (product_id.nil? or product_id.blank?) ? Product.all : product_id)
  end
  
  def total_price
    price = line_items.to_a.sum { |line| line.total_price }
  end
  
  def self.search(params = {})
    if not params.empty?
      start_date = DateTime.parse "#{params[:begin_date]}" unless params[:begin_date].blank?
      finish_date = DateTime.parse "#{params[:end_date]}" unless params[:end_date].blank?
      p = Product.find(params[:product_id]) unless params[:product_id].blank?
      c = Client.find(params[:client_id]) unless params[:client_id].blank?
      pm = PaymentMethod.find(params[:payment_method_id]) unless params[:payment_method_id].blank?
      s = params[:status] unless params[:status].blank?
      invoices = []
    
      clients = c.nil? ? Client.all.sort : Client.where(id: c.id).sort
      
      clients.each do |client|
        if s.nil?
          if p.nil?
            invoices += pm.nil? ? (start_date.nil? ? client.invoices : client.invoices.where("invoices.expiration_date between ? and ?", start_date, (finish_date.nil? ? start_date.end_of_year : finish_date))) : client.invoices.find_all_by_payment_method_id(pm)
          else
            invoices += pm.nil? ? (start_date.nil? ? p.invoices.find_all_by_client_id(client.id) : p.invoices.where("client_id = ? and invoices.expiration_date between ? and ?", client.id, start_date, (finish_date.nil? ? start_date.end_of_year : finish_date))) : client.invoices.find_all_by_payment_method_id(pm)
          end
        else
          invoices += pm.nil? ? client.invoices.find_all_by_status(s) : client.invoices.find_all_by_payment_method_id_and_status(pm, s)
        end
      end
      invoices.sort
    else
      scoped
    end
  end
  
  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(13)
    id = header[2].split("-").join("").to_i
    invoice = find_by_id(id) || new
    client_data = spreadsheet.row(14)
    client = Client.find_by_code(client_data[2].split("-").join(""))
    invoice.id = id
    invoice.client = client
    date = spreadsheet.row(16)[1]
    invoice.created_at = DateTime.parse(date.to_s) unless date.nil?
    invoice.expiration_date = invoice.created_at + 1.month
    data = spreadsheet.row(18)
    tax = spreadsheet.row(46)[3].split(" ")
    payment_method = spreadsheet.row(48)[0].nil? ? spreadsheet.row(47)[0].split(":").last : spreadsheet.row(48)[0].split(":").last
    (20..spreadsheet.last_row).each do |i|
      row = Hash[[data, spreadsheet.row(i)].transpose]
      unless row["CANTIDAD"].to_i == 0
        product_code = row["COD PRODUCTO"].to_i
        product = Product.find_by_code(product_code)
        discount = row["% DESC"].to_i * 100
        invoice.line_items.new(
          quantity: row["CANTIDAD"].to_i,
          product_id: product.id,
          #discount: discount || (0 if discount.blank?),
        )
        invoice.payment_method_id = PaymentMethod.find_or_create_by_name(payment_method).id unless payment_method.nil? or payment_method.blank?
        invoice.save!
        t = Tax.find_or_create_by_value_and_name(tax.first.split("%").first.to_i, tax.last)
        Rate.find_or_create_by_tax_id_and_invoice_id(t.id, invoice.id)
      end
    end
  end

=begin
  def self.open_spreadsheet(file)
    case File.extname(file)
    when ".csv" then Roo::Csv.new(file, nil, :ignore)
    when ".ods" then Roo::Openoffice.new(file, nil, :ignore)
    when ".xls" then Roo::Excel.new(file, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file, nil, :ignore)
    else raise "Unknown file type: #{file}"
    end
  end
=end

#=begin    
  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
    when ".ods" then Roo::Openoffice.new(file.path, nil, :ignore)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
#=end
end
