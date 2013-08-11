# encoding: UTF-8

class Estimate < ActiveRecord::Base
  belongs_to :client
  belongs_to :user
  belongs_to :tax
  has_many :line_items, dependent: :destroy
  has_many :products, through: :line_items
  has_one :project, dependent: :destroy
  has_many :items, through: :products
  
  delegate :discount, to: :client
  
  accepts_nested_attributes_for :line_items
  accepts_nested_attributes_for :client
  #accepts_nested_attributes_for :project
  
  attr_accessible :number, :client_id, :line_items_attributes, :observations, :delivary_date, :expiration_date,
    :created_at, :tax_id, :total_price, :client, :user_id
  
  validates :client_id, presence: { message: " no puede estar en blanco." }
  validates :tax_id, presence: { message: " no puede estar en blanco." }
  
  def to_param
    number
  end

  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end

  def total_items
    line_items.sum :quantity 
  end
	
  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(17)
    id = header.first.split(" ").last.include?("º") ? header.first.split(" ").last.split("º").last.to_i : header.first.split(" ").last.to_i
    data = spreadsheet.row(19)
    tax_data = spreadsheet.row(50)[2].split(" ") unless spreadsheet.row(50)[2].nil?
    client_data = spreadsheet.row(9)
    client_name = spreadsheet.row(8)[3].split(":").last.strip == "CLIENTE" ? spreadsheet.row(9)[3].strip : spreadsheet.row(8)[3].split(":").last.strip
    client_name = client_name.split(" ").join(" ")
    client = Client.find_or_create_by_code_and_name(client_data.first.split("-").join("").strip, client_name)
    delivery_date = client_data[1]
    delivery_note = find_by_id(id) || new
    estimate.attributes = {
      id: id,
      client_id: client.id
    }
    tax_id = tax_data.nil? ? nil : Tax.find_or_create_by_value_and_name(tax_data.first.split("%").first.to_i, tax_data.last.split(".").join("")).id
    (20..spreadsheet.last_row).each do |i|
      row = Hash[[data, spreadsheet.row(i)].transpose]
      unless row["CANTIDAD"].to_i == 0
        product_code = row["COD. PRODUCTO"].to_i
        discount = row["% DTO"].to_f * 100
        estimate.line_items.new(
          quantity: row["CANTIDAD"].to_i,
          product_id: Product.find_by_code(product_code).id
        )
        estimate.client.discount = Discount.find_by_client_id(client.id) || Discount.create(client_id: client.id, value: discount)
        estimate.tax_id = tax_id
        estimate.delivery_date = delivery_date
        estimate.save!
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
    else raise "Unknown file type: #{file}"
    end
  end
#=end

  def self.search(params = {})
    if not params.empty?
      start_date = DateTime.parse "01/01/#{params[:year]}" unless params[:year].blank?
      p = Product.find(params[:product_id]) unless params[:product_id].blank?
      c = Client.find(params[:client_id]) unless params[:client_id].blank?
      estimates = []
    
      clients = c.nil? ? Client.all.sort : Client.where(id: c.id).sort
      
      clients.each do |client|
        if p.nil?
          estimates += start_date.nil? ? client.estimates : client.invoices.where("invoices.created_at between ? and ?", start_date, start_date.end_of_year)
        else
          estimates += start_date.nil? ? p.estimates.where("client_id = ?", client.id) : p.estimates.where("client_id = ? and invoices.created_at between ? and ?", client.id, start_date, start_date.end_of_year)
        end
      end
      estimates.sort
    else
      scoped
    end
  end
end
