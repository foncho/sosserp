# encoding: UTF-8

class Client < ActiveRecord::Base
  has_one :discount
  has_many :delivery_notes
  has_many :invoices
  has_many :line_items, through: :invoices
  has_many :products, through: :line_items
  belongs_to :client_type
  
  accepts_nested_attributes_for :discount
  
  attr_accessible :address, :cif, :city, :code, :contact, :country, :client_type_id,
    :email, :fax, :name, :observations, :phone, :postcode, :province, :discount
    
  def zone_name=(name)
    zone = Zone.find_by_name(name)
    if zone
      self.zone_id = zone.id
    else
      errors[:zone_name] << "El nombre introducido no es válido."
    end
  end

  def zone_name
    Zone.find(zone_id).name if zone_id
  end
        
  def self.search(params = {})
    if not params.empty?
      clients = []
      if not params[:client_type_id].blank?
        ct = ClientType.find_by_name(params[:client_type_id])
        clients = ct.nil? ? Client.all.sort : ct.clients.sort
      else
        clients = all.sort
      end
      clients.sort
    else
      all.sort
    end
  end
  
  def search(term)
    find_by_name(term)
  end
  
  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |client|
        csv << client.attributes.values_at(*column_names)
      end
    end
  end
  
  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      client = find_by_code(row["code"]) || new
      client.attributes = row.to_hash.slice(*accessible_attributes)
      client.save!
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
end
