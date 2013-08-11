# encoding: UTF-8

class Product < ActiveRecord::Base
  has_many :line_items
  has_many :item_products
  has_many :items, through: :item_products
  has_many :estimates, through: :line_items
  has_many :invoices, through: :line_items
  belongs_to :description
  
  accepts_nested_attributes_for :items
  
  attr_accessible :code, :name, :items_attributes
   
  validates_presence_of :code, :name
  
  def availability
    line_items.where("delivery_note_id IS NULL AND invoice_id IS NULL").sum(:quantity) - 
    (delivery_notes.to_a.sum { |dn| dn.line_items.where(product_id: id).sum :quantity }) - 
    (delivery_notes.to_a.sum { |dn| dn.line_items.where(product_id: id).sum { |line| (line.problems.empty? ? 0 : (line.problems.sum :broken)) } })
  end
  
  def self.tokens(query)
    products = if not query.nil?
      where("name like ? or name like ? or name like ?", "%#{query.capitalize}%", "%#{query.upcase}%", "%#{query.downcase}%")
    else
      scoped
    end
    
    results = []
    
    products.each do |p|
      results << p.name
    end
    
    results
  end

  def self.id_from_token(token)
    find_by_name(token).id
  end

  def self.ids_from_tokens(tokens)
    tokens.gsub!(/<<<(.+?)>>>/) { find_or_create!(name: $1.split(" ").map { |w| w.capitalize }.join(" ")).id }
    tokens.split(',')
  end
  
  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |product|
        csv << product.attributes.values_at(*column_names)
      end
    end
  end
  
  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      product = find_by_code(row["code"]) || new
      product.attributes = row.to_hash.slice(*accessible_attributes)
      product.save!
      price = Price.find_or_create_by_value_and_product_id(row["unit_price"], product.id)
    end
  end
  
  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
    when ".ods" then Roo::Openoffice.new(file.path, nil, :ignore)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
  
  def self.search(params = {})
    unless params.nil?
      return find(params)
    else
      nil
    end
  end
end
